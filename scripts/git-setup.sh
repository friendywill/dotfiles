# Check if gh CLI is authenticated
if ! gh auth status >/dev/null 2>&1; then
	echo "Please log in to GitHub CLI."
	gh auth login --hostname github.com
fi
# Refresh auth with scope of the user to gain permission to add GPG key
gh auth refresh -h github.com -s user
# Backup any previous git configuration
mkdir -p ~/.backup
mv ~/.gitconfig ~/.backup/
# Make GNU pretty good privacy directory if it doesn't exist
mkdir -p ~/.gnupg
export GNUPGHOME="~/.gnupg"
github_username=$(gh api user --jq '.login')
emails=$(gh api user/emails --jq '.[].email')

# Check for existing GPG keys
existing_keys=$(gpg --list-keys --keyid-format LONG | grep '^pub' | awk '{print $2}' | cut -d'/' -f2)

# Check if a GPG key exists on GitHub
existing_gpg_keys=$(gh api /user/gpg_keys --jq '.[].key_id')

# Check which keys are currently on Github, and on the local device.
for key_id in $existing_gpg_keys; do
	if echo "$existing_keys" | grep -q "$key_id"; then
		existing_gpg_keys="$key_id"
		echo $existing_gpg_keys
		break
	fi
done

# Prompt user to select an email address that exists on github
echo "Choose an email address to use for Git configuration:"
index=1
selected_email=""
for email in $emails; do
	echo "$index. $email"
	index=$((index + 1))
done

while true; do
	read -p "Enter the number of the email address you want to use: " choice
	selected_email=$(echo "$emails" | sed -n "${choice}p")
	break
done

github_email="$selected_email"
# Function to generate a new GPG key
generate_gpg_key() {
	cat >/tmp/tmpgit <<EOF
    %no-protection
    %no-ask-passphrase
    %echo Generating PGP Key for Github
    Key-Type: RSA
    Key-Length: 4096
    Subkey-Type: RSA
    Subkey-Length: 4096
    Name-Real: $github_username
    Name-Email: $github_email
    Expire-Date: 0
    Key-Usage: auth,sign
    %commit
    %echo done
EOF
	key_id=$(gpg --batch --generate-key /tmp/tmpgit 2>&1 | awk -F/ '/^gpg: revocation certificate stored as/ { sub(/\.rev.*/, "", $NF); print $NF }')
	rm /tmp/tmpgit
	gh auth refresh -s write:gpg_key
	gpg --armor --export $key_id >/tmp/tmpgitkeypublic

	read -p "Enter a title for the GPG key [${HOST}]: " key_title
	key_title=${key_title:-$HOST}
	gh gpg-key add /tmp/tmpgitkeypublic -t "$key_title"
}

# Prompt to add a GPG key if none exist on the machine
if [ -z "$existing_keys" ]; then
	read -p "No GPG keys found on this machine. Would you like to generate a new GPG key for GitHub? (y/n): " generate_key
	if [ "$generate_key" = "y" ]; then
		generate_gpg_key
	fi
else
	echo "Existing GPG keys found on this machine:"
	echo "$existing_keys" | nl -w 2 -s '. '

	if [ -z "$existing_gpg_keys" ]; then
		echo "No GPG keys found on GitHub."
		read -p "Would you like to add an existing key or generate a new one? (e: existing / n: new): " add_key_choice
		if [ "$add_key_choice" = "e" ]; then
			read -p "Select a key number to add: " key_number
			key_id=$(echo "$existing_keys" | sed -n "${key_number}p")
			gpg --armor --export $key_id >/tmp/tmpgitkeypublic

			read -p "Enter a title for the GPG key [${HOST}]: " key_title
			key_title=${key_title:-$HOST}
			gh gpg-key add /tmp/tmpgitkeypublic -t "$key_title"
		elif [ "$add_key_choice" = "n" ]; then
			generate_gpg_key
		fi
	else
		echo "GPG keys already exist on GitHub: $existing_gpg_keys"
		read -p "Would you like to keep the (e)xisting key, add a local (d)ifferent existing key, or (g)enerate a new one? (e: existing / d: different existing / g: generate another): " github_key_choice
		if [ "$github_key_choice" = "a" ]; then
			read -p "Select a key number to add: " key_number
			key_id=$(echo "$existing_keys" | sed -n "${key_number}p")
			gpg --armor --export $key_id >/tmp/tmpgitkeypublic

			read -p "Enter a title for the GPG key [${HOST}]: " key_title
			key_title=${key_title:-$HOST}
			gh gpg-key add /tmp/tmpgitkeypublic -t "$key_title"
		elif [ "$github_key_choice" = "d" ]; then
			generate_gpg_key
		elif [ "$github_key_choice" = "e" ]; then
			$key_id=$existing_gpg_keys
		fi
	fi
fi

cat >~/.gitconfig <<EOF
[credential "https://github.com"]
    helper = 
    helper = !/usr/local/bin/gh auth git-credential
[credential "https://gist.github.com"]
    helper = 
    helper = !/usr/local/bin/gh auth git-credential
[commit]
    gpgsign = true
[user]
    signingKey = $key_id
    name = $github_username 
    email = $github_email
EOF

echo "Git setup completed."

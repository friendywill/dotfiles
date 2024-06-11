gh auth login --hostname github.com --git-protocol ssh
gh auth setup-git
mkdir ~/.backup
mv ~/.gitconfig ~/.backup/
mkdir ~/.gnupg
export GNUPGHOME="~/.gnupg"
github_username=$(gh api user --jq '.login')
github_email=$(gh api user/emails --jq '.email')
cat >tmpgit <<EOF
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
key_id=$(gpg --batch --generate-key tmpgit 2>&1 | awk -F/ '/^gpg: revocation certificate stored as/ { sub(/\.rev.*/, "", $NF); print $NF }')
rm tmpgit
gh auth refresh -s write:gpg_key
gpg --armor --export $key_id | gh gpg-key add $HOST -
cat >.gitconfig <<EOF
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

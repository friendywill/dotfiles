gh auth login
gh auth setup-git
mkdir ~/.gnupg
export GNUPGHOME="~/.gnupg"
cat >tmpgit <<EOF
	%no-protection
	%no-ask-passphrase
	%echo Generating PGP Key for Github
	Key-Type: RSA
	Key-Length: 4096
	Subkey-Type: RSA
	Subkey-Length: 4096
	Name-Real: friendywill
	Name-Email: will@friendy.dev
	Expire-Date: 0
	Key-Usage: auth,sign
	%commit
	%echo done
EOF
key_id=$(gpg --batch --generate-key tmpgit 2>&1 | awk -F/ '/^gpg: revocation certificate stored as/ { sub(/\.rev.*/, "", $NF); print $NF }')
rm tmpgit
gh auth refresh -s write:gpg_key
gpg --armor --export $key_id | gh gpg-key add -t $HOST -

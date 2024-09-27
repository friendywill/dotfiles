sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply friendywill
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew bundle --file=~/.local/share/chezmoi/Brewfile
chsh -s $(which zsh)
zsh

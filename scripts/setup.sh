sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply friendywill
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
export PATH=/home/linuxbrew/.linuxbrew/bin/:$PATH
brew bundle --file=~/.local/share/chezmoi/Brewfile
sudo ln -s $(which zsh) /bin/zsh
chsh -s $(which zsh)
zsh

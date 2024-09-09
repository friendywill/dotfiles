nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export ZDOTDIR="$HOME"/.config/zsh

mkdir ~/.config/
ln -s ~/dotfiles/.config/* ~/.config
sudo mkdir /etc/zsh/
sudo cp $HOME/dotfiles/zshenv /etc/zsh/zshenv
nix-shell '<home-manager>' -A install
chsh -s $(which zsh)
zsh

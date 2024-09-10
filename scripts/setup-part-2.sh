nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export ZDOTDIR="$HOME"/.config/zsh

mkdir ~/.config/
ln -s ~/dotfiles/.config/* ~/.config
sudo mkdir /etc/zsh/
sudo cp $HOME/dotfiles/zshenv /etc/zsh/zshenv
nix-shell '<home-manager>' -A install
chsh -s $(which zsh)
git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.local/share/oh-my-zsh/
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.local/share/oh-my-zsh/custom/themes/powerlevel10k
git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm
zsh

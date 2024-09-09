curl -L https://nixos.org/nix/install | sh -s -- --daemon
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

mkdir ~/.config/
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.config/* ~/.config
nix-shell '<home-manager>' -A install
echo 'export ZDOTDIR="$HOME"/.config/zsh' | sudo tee -a /etc/zsh/zshenv > /dev/null
chsh -s $(which zsh)
zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git $XDG_DATA_HOME/oh-my-zsh/
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $XDG_DATA_HOME/.oh-my-zsh/custom/themes/powerlevel10k
git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm

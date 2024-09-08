git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm
mkdir ~/.config/
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.config/* ~/.config
git clone https://github.com/ohmyzsh/ohmyzsh.git $XDG_DATA_HOME/oh-my-zsh/
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $XDG_DATA_HOME/.oh-my-zsh/custom/themes/powerlevel10k
echo 'export ZDOTDIR="$HOME"/.config/zsh' | sudo tee -a /etc/zsh/zshenv > /dev/null
chsh -s $(which zsh)
zsh

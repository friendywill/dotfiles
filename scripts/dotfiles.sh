git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s "~/dotfiles/.p10k.zsh" ~/.p10k.zsh
ln -s "~/dotfiles/.tmux" ~/.tmux
ln -s "~/dotfiles/.vim" ~/.vim
ln -s "~/dotfiles/.zprofile" ~/.zprofile
ln -s "~/dotfiles/.zshrc" ~/.zshrc
ln -s "~/dotfiles/.tmux.conf" ~/.tmux.conf
ln -s "~/dotfiles/.config/" ~/.config
ln -s "~/dotfiles/.gitconfig" ~/.gitconfig
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh/
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
chsh -s $(which zsh)
zsh source ~/.zshrc

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/oh-my-zsh.sh -o $HOME/.oh-my-zsh/oh-my-zsh.sh
source ~/.zshrc

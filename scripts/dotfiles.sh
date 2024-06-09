sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s "$SCRIPT_DIR/../.p10k.zsh" ~/.p10k.zsh
ln -s "$SCRIPT_DIR/../.tmux" ~/.tmux
ln -s "$SCRIPT_DIR/../.vim" ~/.vim
ln -s "$SCRIPT_DIR/../.zprofile" ~/.zprofile
ln -s "$SCRIPT_DIR/../.zshrc" ~/.zshrc
ln -s "$SCRIPT_DIR/../.tmux.conf" ~/.tmux.conf
ln -s "$SCRIPT_DIR/../.config/" ~/.config
ln -s "$SCRIPT_DIR/../.gitconfig" ~/.gitconfig
git clone https://github.com/ohmyzsh/ ~/.oh-my-zsh/
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

source ~/.zshrc

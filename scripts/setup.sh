nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export ZDOTDIR="$HOME"/.config/zsh
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hermit.zip &&
  cd ~/.local/share/fonts &&
  unzip Hermit.zip &&
  rm Hermit.zip &&
  fc-cache -fv &&
  cd ~/
mkdir ~/.config/
ln -s ~/dotfiles/.config/* ~/.config
sudo mkdir /etc/zsh/
sudo cp $HOME/dotfiles/zshenv /etc/zsh/zshenv
nix-shell '<home-manager>' -A install
install_zsh() {
    case "$1" in
        apt)
            sudo apt update && sudo apt install -y zsh
            ;;
        yum)
            sudo yum install -y zsh
            ;;
        dnf)
            sudo dnf install -y zsh
            ;;
        pacman)
            sudo pacman -Syu --noconfirm zsh
            ;;
        zypper)
            sudo zypper install -y zsh
            ;;
        brew)
            brew install zsh
            ;;
        nix-env)
            nix-env -iA nixpkgs.zsh
            ;;
        *)
            echo "Package manager not supported or not detected"
            exit 1
            ;;
    esac
}

# Detect the package manager
if command -v apt >/dev/null 2>&1; then
    install_zsh apt
elif command -v yum >/dev/null 2>&1; then
    install_zsh yum
elif command -v dnf >/dev/null 2>&1; then
    install_zsh dnf
elif command -v pacman >/dev/null 2>&1; then
    install_zsh pacman
elif command -v zypper >/dev/null 2>&1; then
    install_zsh zypper
elif command -v brew >/dev/null 2>&1; then
    install_zsh brew
elif command -v nix-env >/dev/null 2>&1; then
    install_zsh nix-env
else
    echo "No supported package manager found."
    exit 1
fi

echo "zsh installation complete."
chsh -s $(which zsh)
git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.local/share/oh-my-zsh/
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.local/share/oh-my-zsh/custom/themes/powerlevel10k
git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm
zsh

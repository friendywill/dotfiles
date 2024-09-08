# shell.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.ripgrep
    pkgs.fzf
    pkgs.curl
    pkgs.git
    pkgs.zsh
    pkgs.docker
    pkgs.wget
    pkgs.nerdfonts
    pkgs.tmux
    pkgs.lazy
    pkgs.nvm
    pkgs.gh
    pkgs.neovim
    pkgs.lazydocker
    pkgs.lazygit
    pkgs.neovim
    pkgs.oh-my-zsh
    pkgs.fzf-zsh
    pkgs.zsh-autocomplete
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
    pkgs.gh
  ];

  shellHook = ''
    # Docker setup
    sudo systemctl start docker
    sudo systemctl enable docker

    # Snap setup (snapd is usually not recommended with NixOS, but for Ubuntu-based systems)
    sudo systemctl start snapd
    sudo systemctl enable snapd
    sudo snap install nvim --classic

    # Git and Zsh customizations
    git clone https://github.com/tmux-plugins/tpm ~/.local/share/tmux/plugins/tpm
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/.oh-my-zsh/custom/themes/powerlevel10k

    # Config configuration
    mkdir -p ~/.config
    ln -s ~/dotfiles/.config/* ~/.config
    echo 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee -a /etc/zsh/zshenv > /dev/null
    chsh -s $(which zsh)
    zsh
  '';
}


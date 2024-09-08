curl -L https://nixos.org/nix/install | sh -s -- --daemon
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
echo 'export ZDOTDIR="$HOME/.config/zsh"' | tee -a /etc/zsh/zshenv > /dev/null

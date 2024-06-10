#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install curl git speedtest-cli ripgrep fd-find wget zsh snapd -y
sudo systemctl unmask snapd.service
sudo systemctl enable snapd.service
sudo systemctl start snapd.service
sudo snap install nvim --classic
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hermit.zip &&
	cd ~/.local/share/fonts &&
	unzip Hermit.zip &&
	rm Hermit.zip &&
	fc-cache -fv &&
	cd ~/
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin
sudo mv ~/.* ~/.backup
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
zsh $SCRIPT_DIR/dotfiles.sh

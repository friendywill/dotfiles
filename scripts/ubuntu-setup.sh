#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install gcc curl git speedtest-cli ripgrep fd-find wget zsh snapd -y
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
git clone https://github.com/zsh-users/zsh-autosuggestions ~/dotfiles/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/dotfiles/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/mafredri/zsh-async ~/dotfiles/.oh-my-zsh/plugins/async
git clone https://github.com/lukechilds/zsh-nvm ~/dotfiles/.oh-my-zsh/custom/plugins/zsh-nvm
git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/dotfiles/.oh-my-zsh/
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/dotfiles/.oh-my-zsh/custom/themes/powerlevel10k
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

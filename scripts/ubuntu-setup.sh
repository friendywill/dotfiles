#!/bin/bash

apt update
apt upgrade -y
apt install curl git speedtest-cli wget zsh snapd -y
systemctl unmask snapd.service
systemctl enable snapd.service
systemctl start snapd.service
snap install nvim --classic
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hermit.zip &&
	cd ~/.local/share/fonts &&
	unzip Hermit.zip &&
	rm Hermit.zip &&
	fc-cache -fv &&
	cd ~/

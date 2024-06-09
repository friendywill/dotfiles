#!/bin/bash

apt update
apt upgrade -y
apt install curl git speedtest-cli wget zsh snapd -y
systemctl unmask snapd.service
systemctl enable snapd.service
systemctl start snapd.service
snap install nvim --classic

#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install ripgrep fzf gcc curl git speedtest-cli ripgrep fd-find wget zsh snapd -y
# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
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
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
sudo mv ~/.local/bin/lazydocker /usr/bin
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/dotfiles/.oh-my-zsh/
git clone https://github.com/zsh-users/zsh-autosuggestions ~/dotfiles/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/dotfiles/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/mafredri/zsh-async ~/dotfiles/.oh-my-zsh/plugins/async
git clone https://github.com/lukechilds/zsh-nvm ~/dotfiles/.oh-my-zsh/custom/plugins/zsh-nvm
git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/dotfiles/.oh-my-zsh/custom/themes/powerlevel10k
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
nvm install --lts
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) &&
  sudo mkdir -p -m 755 /etc/apt/keyrings &&
  wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
  sudo apt update &&
  sudo apt install gh -y

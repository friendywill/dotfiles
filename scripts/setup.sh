#!/bin/sh
# Apply my dotfiles config using the chezmoi manager
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply friendywill
# Installing homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
export PATH=/home/linuxbrew/.linuxbrew/bin/:$PATH
brew bundle --file=~/.local/share/chezmoi/Brewfile

# Install zsh based on package manager available
# Function to install zsh using a package manager
install_zsh() {
  echo "Installing zsh using $1..."
  $2
  echo "zsh installation complete."
}

# Detect package manager and install zsh accordingly
if command -v apt >/dev/null 2>&1; then
  # For Debian/Ubuntu-based systems
  install_zsh "apt" "sudo apt install zsh -y"
elif command -v dnf >/dev/null 2>&1; then
  # For Fedora
  install_zsh "dnf" "sudo dnf install zsh -y"
elif command -v pacman >/dev/null 2>&1; then
  # For Arch Linux
  install_zsh "pacman" "sudo pacman -S zsh --noconfirm"
elif command -v zypper >/dev/null 2>&1; then
  # For openSUSE
  install_zsh "zypper" "sudo zypper install zsh -y"
elif command -v brew >/dev/null 2>&1; then
  # For macOS/Homebrew
  install_zsh "brew" "brew install zsh"
else
  echo "No compatible package manager found. Please install zsh manually."
  exit 1
fi

# Verify the installation
if command -v zsh >/dev/null 2>&1; then
  echo "zsh successfully installed."
else
  echo "zsh installation failed."
  exit 1
fi

#install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Install devbox
curl -fsSL https://get.jetify.com/devbox | bash

# Install cargo (Rust)
curl https://sh.rustup.rs -sSf | sh

chsh -s /bin/zsh
zsh

wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hermit.zip &&
  cd ~/.local/share/fonts &&
  unzip Hermit.zip &&
  rm Hermit.zip &&
  fc-cache -fv &&
  cd ~/

#!/usr/bin/env bash

read -p "Do you want to install tmux config? (y/n): " tmux
if [[ "$tmux" =~ ^[Yy]$ ]]; then
    echo "Installing tmux configuration..."
    /usr/bin/env bash <(curl https://hjestaedt.github.io/dotfiles/tmux/install.sh)
fi

read -p "Do you want to install starship config? (y/n): " starship
if [[ "$starship" =~ ^[Yy]$ ]]; then
    echo "Installing starship configuration..."
    /usr/bin/env bash <(curl https://hjestaedt.github.io/dotfiles/starship/install.sh)
fi

read -p "Do you want to install dircolors config? (y/n): " dircolors 
if [[ "$dircolors" =~ ^[Yy]$ ]]; then
    echo "Installing dircolors configuration..."
    /usr/bin/env bash <(curl https://hjestaedt.github.io/dotfiles/dircolors/install.sh)

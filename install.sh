#!/usr/bin/env bash

read -p "Do you want to install tmux config? (y/n): " tmux
if [[ "$tmux" =~ ^[Yy]$ ]]; then
    echo "Installing tmux configuration..."
    /usr/bin/env bash <(curl https://hjestaedt.github.io/dotfiles/tmux/install.sh)
fi

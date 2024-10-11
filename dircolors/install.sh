#!/bin/bash

# Enable strict error handling
set -euo pipefail

# Constants
readonly DIRCOLORS_FILE="$HOME/.dircolors"
readonly BASHRC="$HOME/.bashrc"
readonly DIRCOLORS_URL="https://hjestaedt.github.io/dotfiles/dircolors/dircolors"
readonly DIRCOLORS_INIT='test -r ~/.dircolors && eval "$(dircolors ~/.dircolors)"'

# Function to create timestamped backup of a file
create_backup() {
    local file="$1"
    local backup="${file}.bak.$(date +%Y%m%d_%H%M%S)"
    
    if [ -f "$file" ]; then
        echo "Creating backup of $file..."
        cp "$file" "$backup" || {
            echo "Failed to create backup of $file. Exiting." >&2
            exit 1
        }
        echo "Backup created at $backup"
    fi
}

# Function to download dircolors config
download_dircolors() {
    echo "Downloading dircolors configuration..."
    if ! curl -fsSL "$DIRCOLORS_URL" -o "$DIRCOLORS_FILE"; then
        echo "Failed to download dircolors configuration. Exiting." >&2
        exit 1
    fi
    echo "Dircolors configuration downloaded successfully."
}

# Function to initialize dircolors in bashrc
initialize_dircolors() {
    # Create backup of .bashrc
    create_backup "$BASHRC"
    
    # Check if initialization is already present
    if ! grep -qF "$DIRCOLORS_INIT" "$BASHRC"; then
        echo "Adding dircolors initialization to .bashrc..."
        printf '\n# Initialize dircolors\n%s\n' "$DIRCOLORS_INIT" >> "$BASHRC"
        echo "Dircolors initialization added to .bashrc."
    else
        echo "Dircolors initialization already present in .bashrc."
    fi
}

# Main function
main() {
    # Ask if user wants to install dircolors config
    read -rp "Do you want to install dircolors configuration? (yes/no): " answer
    if [[ ! "$answer" =~ ^[Yy]es$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi

    # Check if dircolors file already exists
    if [ -f "$DIRCOLORS_FILE" ]; then
        read -rp "Dircolors configuration already exists. Do you want to overwrite it? (yes/no): " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]es$ ]]; then
            echo "Installation cancelled."
            exit 0
        fi
        
        # Create backup of existing configuration
        create_backup "$DIRCOLORS_FILE"
    fi

    # Download new dircolors configuration
    download_dircolors

    # Initialize dircolors in .bashrc
    initialize_dircolors

    echo "Dircolors installation complete. Please restart your terminal or run 'source ~/.bashrc' to apply changes."
}

# Run main function
main "$@":1

#!/bin/bash

# Function to check if Starship is already installed
check_starship_installed() {
    if command -v starship &> /dev/null; then
        echo "Starship is already installed."
        return 0
    else
        return 1
    fi
}

# Function to add directory to PATH if not already present
add_to_path() {
    local dir="$1"
    local BASHRC="$HOME/.bashrc"
    
    # Check if the directory is already in PATH
    if [[ ":$PATH:" != *":$dir:"* ]]; then
        echo "Adding $dir to PATH in .bashrc..."
        echo "export PATH=\"$dir:\$PATH\"" >> "$BASHRC"
        echo "Directory $dir added to PATH. Please restart your terminal or run 'source ~/.bashrc'."
    else
        echo "Directory $dir is already in PATH."
    fi
}

# Function to install Starship
install_starship() {
    # Prompt the user for the installation directory with a default value
    read -p "Enter the installation directory (default: $HOME/bin): " install_dir
    install_dir=${install_dir:-$HOME/bin}

    # Check if the directory exists, create it if it doesn't
    if [ ! -d "$install_dir" ]; then
        echo "Directory $install_dir does not exist. Creating it now..."
        mkdir -p "$install_dir"
        if [ $? -ne 0 ]; then
            echo "Failed to create directory $install_dir. Exiting."
            exit 1
        fi
        # Add the newly created directory to PATH
        add_to_path "$install_dir"
    fi

    echo "Installing Starship to $install_dir..."
    curl -o install.sh -sS https://starship.rs/install.sh
    sh ./install.sh -b "$install_dir"
}

# Function to initialize Starship in .bashrc
initialize_starship() {
    local BASHRC="$HOME/.bashrc"
    local STARSHIP_INIT='eval "$(starship init bash)"'

    # Check if the initialization line already exists in .bashrc
    if ! grep -qF "$STARSHIP_INIT" "$BASHRC"; then
        # Add the line to the end of .bashrc
        echo "$STARSHIP_INIT" >> "$BASHRC"
        echo "Starship initialization added to .bashrc."
    else
        echo "Starship initialization is already present in .bashrc."
    fi
}

# Function to set up Starship config
setup_starship_config() {
    local CONFIG_DIR="$HOME/.config"
    local CONFIG_FILE="$CONFIG_DIR/starship.toml"
    local BACKUP_FILE="$CONFIG_FILE.bak"
    local CONFIG_URL="https://hjestaedt.github.io/dotfiles/starship/starship.toml"

    # Check if the config directory exists, create it if it doesn't
    if [ ! -d "$CONFIG_DIR" ]; then
        echo "Creating config directory $CONFIG_DIR..."
        mkdir -p "$CONFIG_DIR"
    fi

    # Check if the config file exists
    if [ -f "$CONFIG_FILE" ]; then
        # Ask if the user wants to overwrite the existing config file
        read -p "The config file $CONFIG_FILE already exists. Overwrite it? (yes/no): " overwrite_answer
        if [[ "$overwrite_answer" =~ ^[Yy]es$ ]]; then
            # Create a backup before overwriting
            echo "Creating a backup of the existing config file..."
            cp "$CONFIG_FILE" "$BACKUP_FILE"
            if [ $? -ne 0 ]; then
                echo "Failed to create a backup of $CONFIG_FILE. Exiting."
                exit 1
            fi
            echo "Backup created at $BACKUP_FILE."
            
            # Overwrite the config file with the new one from GitHub
            echo "Downloading new config file..."
            curl -o "$CONFIG_FILE" -sS "$CONFIG_URL"
            echo "Config file overwritten."
        else
            echo "Keeping the existing config file."
        fi
    else
        # Download the config file since it doesn't exist
        echo "Config file does not exist. Downloading from GitHub..."
        curl -o "$CONFIG_FILE" -sS "$CONFIG_URL"
        echo "Config file downloaded to $CONFIG_FILE."
    fi
}

#
# main script
#

if check_starship_installed; then
    # If Starship is already installed, proceed to initialization
    initialize_starship
else
    # If Starship is not installed, ask the user if they want to install it
    read -p "Starship is not installed. Would you like to install it now? (yes/no): " answer

    # Check if the answer is 'yes' (case insensitive)
    if [[ "$answer" =~ ^[Yy]es$ ]]; then
        # Call the installation function
        install_starship
        # Call the initialization function after installation
        initialize_starship
    else
        echo "Installation canceled."
        exit 0
    fi
fi

# Set up the Starship config file
setup_starship_config

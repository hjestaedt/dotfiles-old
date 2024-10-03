#!/bin/bash

TMUX_CONF="$HOME/.tmux.conf"
TMUX_CONF_BACKUP="$HOME/.tmux.conf.backup_$(date +%Y%m%d_%H%M%S)"
TPM_DIR="$HOME/.tmux/plugins/tpm"
TMP_CONF="$HOME/.tmux.conf.tmp"

TMUX_URL="https://raw.githubusercontent.com/hjestaedt/dotfiles/main/tmux/tmux.config"
TMUX_URL_BASE="https://raw.githubusercontent.com/hjestaedt/dotfiles/main/tmux/tmux-base.config"


# clean up temporary files on exit
cleanup() {
    [ -f "$TMP_CONF" ] && rm -f "$TMP_CONF"
}
trap cleanup EXIT


# check if tmux is installed
check_tmux_installed() {
    if ! command -v tmux &> /dev/null; then
        echo "tmux is not installed"
        exit 1
    fi
}


# download tmux.conf to a temporary file
download_tmux_conf() {
    echo "downloading new tmux.conf..."
    
    if ! curl -sSfLo "$TMP_CONF" "$DOWNLOAD_URL"; then
        echo "failed to download tmux.conf"
        return 1
    fi
    return 0
}


# backup the existing tmux.conf
backup_tmux_conf() {
    echo "backing up existing .tmux.conf to $TMUX_CONF_BACKUP"
    mv "$TMUX_CONF" "$TMUX_CONF_BACKUP"
}


# install the new tmux.conf
install_tmux_conf() {
    mv "$TMP_CONF" "$TMUX_CONF"
    chmod 644 "$TMUX_CONF"
    echo "tmux.conf installed at $TMUX_CONF"
}


# handle case where tmux.conf already exists
handle_existing_tmux_conf() {
    echo "$TMUX_CONF already exists."
    while true; do
        read -r -p "do you want to to override the existing file? (y/n): " user_input
        case "$user_input" in
            [Yy]* )
                if download_tmux_conf; then
                    backup_tmux_conf
                    install_tmux_conf
                    if $INSTALL_TPM; then
                      install_tpm
                    fi
                fi
                break
                ;;
            [Nn]* )
                echo "aborting script"
                exit 0
                ;;
            * )
                echo "invalid input, please enter 'y' or 'n'"
                ;;
        esac
    done
}


# install TPM
install_tpm() {
    if [ ! -d "$TPM_DIR" ]; then
        echo "installing tmux plugin manager (tpm)..."
        if ! git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"; then
            echo "failed to clone tpm repository"
            return 1
        fi
    else
        echo "updating tmux plugin manager (tpm)..."
        if ! (cd "$TPM_DIR" && git pull); then
            echo "failed to update tpm repository"
            return 1
        fi
    fi
    return 0
}


# main script 
check_tmux_installed

while true; do
    read -r -p "do you also want to install the tmux plugin manager (tpm)) (y/n)? " tpm_input
    case "$tpm_input" in
        [Yy]* )
            DOWNLOAD_URL=$TMUX_URL
            INSTALL_TPM=true
            break
            ;;
        [Nn]* )
            DOWNLOAD_URL=$TMUX_URL_BASE
            INSTALL_TPM=false
            break
            ;;
        * )
            echo "invalid input. Please enter 'y' or 'n'."
            ;;
    esac
done

if [ -f "$TMUX_CONF" ]; then
    handle_existing_tmux_conf
else
    if download_tmux_conf; then
        install_tmux_conf
        if $INSTALL_TPM; then 
            install_tpm
        fi
    fi
fi


#!/bin/bash

CONF_DIR="${HOME}/.config/tmux"
CONF_FILE="${CONF_DIR}/tmux.conf"
CONF_FILE_BACKUP="${CONF_FILE}_$(date +%Y%m%d_%H%M%S)"
CONF_FILE_TMP="${CONF_FILE}.tmp"
TPM_DIR="${CONF_DIR}/plugins/tpm"

CONF_DOWNLOAD_FULL="https://hjestaedt.github.io/dotfiles/tmux/tmux.conf"
CONF_DOWNLOAD_BASE="https://hjestaedt.github.io/dotfiles/tmux/tmux-base.conf"

DOWNLOAD_URL=
INSTALL_TPM=


# check if tmux is installed
check_tmux_installed() {
    if ! command -v tmux &> /dev/null; then
        echo "tmux is not installed"
        exit 1
    fi
}


# clean up temporary files on exit
cleanup() {
    [ -f "$CONF_FILE_TMP" ] && rm -f "$CONF_FILE_TMP"
}
trap cleanup EXIT


# create tmux config directory if it does not exist
create_tmux_home() {
    if [ ! -d "$CONF_DIR" ]; then
        echo "creating tmux config directory $CONF_DIR"
        mkdir -p "$CONF_DIR"
    fi
}


# download tmux.conf to a temporary file
download_tmux_conf() {
    echo "downloading new tmux.conf..."
    
    if ! curl -sSfLo "$CONF_FILE_TMP" "$DOWNLOAD_URL"; then
        echo "failed to download conf file from $DOWNLOAD_URL"
        return 1
    fi
    return 0
}


# backup the existing tmux.conf
backup_tmux_conf() {
    echo "backing up existing .tmux.conf to $CONF_FILE_BACKUP"
    mv "$CONF_FILE" "$CONF_FILE_BACKUP"
}


# install the new tmux.conf
install_tmux_conf() {
    mv "$CONF_FILE_TMP" "$CONF_FILE"
    chmod 644 "$CONF_FILE"
    echo "tmux.conf installed at $CONF_FILE"
}


# handle case where tmux.conf already exists
handle_existing_tmux_conf() {
    echo "$CONF_FILE already exists."
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


#
# main script 
#

check_tmux_installed

while true; do
    read -r -p "do you want to install tpm (tmux plugin manager)? (y/n) " tpm_input
    case "$tpm_input" in
        [Yy]* )
            INSTALL_TPM=true
            DOWNLOAD_URL=$CONF_DOWNLOAD_FULL
            break
            ;;
        [Nn]* )
            INSTALL_TPM=false
            DOWNLOAD_URL=$CONF_DOWNLOAD_BASE
            break
            ;;
        * )
            echo "invalid input. Please enter 'y' or 'n'."
            ;;
    esac
done

if [ -f "$CONF_FILE" ]; then
    handle_existing_tmux_conf
else
    create_tmux_home
    if download_tmux_conf; then
        install_tmux_conf
        if $INSTALL_TPM; then 
            install_tpm
        fi
    fi
fi


#!/usr/bin/env bash

BASHRC="$HOME/.bashrc"
BASHRC_DIR="$HOME/.bashrc.d"
BASHRC_DIR_ESCAPED="\$HOME/.bashrc.d"

#  check operating system
while [ -z "$OS" ]; do
    read -p "linux or macos? [l/m] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ll]$ ]]; then
        OS="linux"
    elif [[ $REPLY =~ ^[Mm]$ ]]; then
        OS="macos"
    else
        echo "invalid input"
        sleep 1
    fi
done

# create bashrc if not exists
if [ ! -f "$BASHRC" ]; then
    echo "creating $BASHRC"
    echo "#!/bin/bash" > "$BASHRC"
    echo >> "$BASHRC"
fi

# create bashrc.d if not exists
if [ ! -d "$BASHRC_DIR" ]; then
    echo "creating $BASHRC_DIR"
    mkdir "$BASHRC_DIR"
fi

# copy all general files to bashrc.d
for file in [0-9]*; do
    echo "installing $file"
    cp -i "$file" "$BASHRC_DIR"
done

# copy all os-specific files to bashrc.d
for file in "$OS"/*; do
    echo "installing $file"
    cp -i "$file" "$BASHRC_DIR"
done

# add source to bashrc if not exist
if  ! grep -Fq "$BASHRC_DIR_ESCAPED" "$BASHRC"; then
    echo "adding source line to $BASHRC"
    cat >> "$BASHRC" <<EOF
# shellcheck disable=SC1090
if [ -d "$BASHRC_DIR_ESCAPED" ]; then for file in "$BASHRC_DIR_ESCAPED"/[0-9]*; do . "\$file"; done; fi
EOF
fi

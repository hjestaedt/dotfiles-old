#!/usr/bin/env bash

BASHRC="$HOME/.bashrc"
BASHRC_DIR="$HOME/.bashrc.d"
BASHRC_DIR_ESCAPED="\$HOME/.bashrc.d"

# delete bashrc.d if exists
if [ -d "$BASHRC_DIR" ]; then
    echo "deleting $BASHRC_DIR"
    rm -rf "$BASHRC_DIR"
fi

# delete source from bashrc if exist
if  grep -Fq "$BASHRC_DIR_ESCAPED" "$BASHRC"; then
    echo "delete source line to $BASHRC"
    sed -i "/disable=SC1090/d" "$BASHRC"
    sed -i "\|$BASHRC_DIR_ESCAPED|d" "$BASHRC"
fi

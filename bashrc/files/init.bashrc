#!/usr/bin/env bash
[ -n "$BASHRC_HOME" ] || { echo "BASHRC_HOME not set"; exit 1; }

alias init.bashrc=". \$BASHRC_HOME/init.bashrc"

# initialize bashrc
for file in "$BASHRC_HOME"/core/* "$BASHRC_HOME"/os/**/* "$BASHRC_HOME"/tool/* "$BASHRC_HOME"/profile/**/*; do
    # shellcheck disable=SC1090
    [ -f "$file" ] && . "$file"
done
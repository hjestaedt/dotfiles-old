#!/usr/bin/env bash
set -euo pipefail

exit_error() {
    [ -n "$1" ] && echo "error: $1" >&2
    exit 1
}

_PATH=$(readlink -f "$0")
_DIR=$(dirname "$_PATH")

[ -f "$_DIR"/.env ] || exit_error ".env not found"
# shellcheck disable=SC1091
. "$_DIR"/.env

# delete bashrc.d if exists
if [ -d "$BASHRC_HOME" ]; then
    echo "deleting $BASHRC_HOME"
    rm -rf "$BASHRC_HOME"
fi

# delete source from bashrc if exist
if  grep -Fq "\$BASHRC_HOME" "$BASHRC_FILE"; then
    echo "delete source line from $BASHRC_FILE"
    sed -i "/BASHRC_HOME/d" "$BASHRC_FILE"
    sed -i "/shellcheck/d" "$BASHRC_FILE"
    sed -i "\|$BASHRC_HOME_UNEXPANDED|d" "$BASHRC_FILE"
fi

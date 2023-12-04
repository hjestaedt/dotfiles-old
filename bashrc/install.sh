#!/usr/bin/env bash
set -euo pipefail

_PATH=$(readlink -f "$0"); declare -r _PATH;
_DIR=$(dirname "$_PATH"); declare -r _DIR;
declare -r _ENV_FILE="$_DIR/.env";
declare -r _USER_ENV_FILE="$_DIR/.user_env";
declare -r _FILE_DIR="$_DIR/files";
declare -r _BASHRC_INIT_FILENAME="init.bashrc"

usage() {
    echo "usage: $0 -p <profile> [-o <os>] [-f]"
    echo "-p <profile>    profile: home, work"
    echo "-o <os>         optional - operating system: linux, macos"
    echo "-f              optional - overwrite files"
    echo "-h              show this help"
    exit 1
}

exit_error() {
    [ -n "$1" ] && echo "error: $1" >&2
    exit 1
}

valid_os() {
  [[ "$1" == "linux" || "$1" == "macos" ]]
}

valid_profile() {
  [[ "$1" == "home" || "$1" == "work" ]]
}

# read environment variables
[ -r "$_ENV_FILE" ] || exit_error "$_ENV_FILE not found or not readable"
# shellcheck disable=SC1090
. "$_ENV_FILE"

# read user environment variables
# shellcheck disable=SC1090
[ -r "$_USER_ENV_FILE" ] && . "$_USER_ENV_FILE"

echo "PROFILE: $PROFILE"
exit

# detect operating system
os_name=$(uname -s)
if [ "$os_name" = "Linux" ]; then
  OS="linux"
elif [ "$os_name" = "Darwin" ]; then
  OS="macos"
else
  exit_error "unsupported os: $os_name"
fi

OVERWRITE=false
# parse arguments
while getopts "o:p:f" opt; do
    case $opt in
        o)  OS="$OPTARG";;
        p)  PROFILE="$OPTARG";;
        f)  OVERWRITE=true;;
        *) usage
    esac
done
declare -r OS PROFILE OVERWRITE

# check mandatory arguments
[ -n "$OS" ] || exit_error "os not specified"
[ -n "$PROFILE" ] || exit_error "profile not specified"

# validate arguments
valid_os "$OS" || exit_error "unsupported os: $OS"
valid_profile "$PROFILE" || exit_error "unknown profile: $PROFILE"

echo "installing bashrc for $OS $PROFILE"

# create $BASHRC_FILE if not exists
if [ ! -f "$BASHRC_FILE" ]; then
    echo "creating $BASHRC_FILE"
    echo "#!/bin/bash" > "$BASHRC_FILE"
    echo >> "$BASHRC_FILE"
fi

# create $BASHRC_HOME if not exists
if [ ! -d "$BASHRC_HOME" ]; then
    echo "creating $BASHRC_HOME"
    mkdir "$BASHRC_HOME"
fi

install_files() {
    [ -n "$1" ] || exit_error "src_dir not specified"
    [ -n "$2" ] || exit_error "dst_dir not specified"
    for file in "$1"/*.bashrc; do
        echo "installing $(basename "$file") to $2"
        if [ "$OVERWRITE" = true ]; then
            cp -f "$file" "$2"
        else
            cp -i "$file" "$2"
        fi
    done
}

create_dir() {
    [ -n "$1" ] || exit_error "dir not specified"
    if [ ! -d "$1" ]; then
        echo "creating $1"
        mkdir -p "$1"
    fi
}

# copy dotfile hierachy to $BASHRC_HOME
for src_dir in "$_FILE_DIR/core" "$_FILE_DIR/tool" "$_FILE_DIR/os/$OS" "$_FILE_DIR/profile/$PROFILE"; do
    create_dir "$BASHRC_HOME/${src_dir#"$_FILE_DIR"/}"
    install_files "$src_dir" "$BASHRC_HOME/${src_dir#"$_FILE_DIR"/}"
done

# copy init.bashrc to $BASHRC_HOME
init_file="$BASHRC_HOME/$_BASHRC_INIT_FILENAME"
cp "$_FILE_DIR/$_BASHRC_INIT_FILENAME" "$init_file"

# add source line to $BASHRC_FILE
if  ! grep -Fq "$BASHRC_HOME_UNEXPANDED" "$BASHRC_FILE"; then
    echo "adding source line to $BASHRC_FILE"
    cat >> "$BASHRC_FILE" <<EOF
# shellcheck disable=SC1091
export BASHRC_HOME="$BASHRC_HOME_UNEXPANDED"
if [ -d "\$BASHRC_HOME" ] && [ -r "\$BASHRC_HOME"/init.bashrc ]; then . "\$BASHRC_HOME"/init.bashrc; fi
EOF
fi

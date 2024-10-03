#!/bin/bash

# check if ls is GNU ls
if [ -z "$(command -v gls)" ]; then
    echo "GNU ls is not installed" >&2
    exit 1
fi

declare -r BASE_DIR="$HOME"
declare -a IGNORED_DIRS=(
    "Applications"
    "Desktop"
    "Documents"
    "Downloads"
    "Library"
    "Movies"
    "Music"
    "Pictures"
    "Public"
)

function construct_ignore_args() {
    local ignore_args=()
    for dir in "${IGNORED_DIRS[@]}"; do
        ignore_args+=("--ignore=$dir")
    done
    echo "${ignore_args[@]}"
}

IGNORE_ARGS="$(construct_ignore_args)"; declare -r IGNORE_ARGS

function is_base_dir() {
    [[ $(realpath "$1") == "$BASE_DIR" ]]
}

function ls_filtered() {
    # shellcheck disable=SC2086
    ls "$@" ${IGNORE_ARGS}
}

function ls_filtered_or_exit() {
    ls_filtered "$@" || exit 1
    exit 0
}

# ls without args in $BASE_DIR
if [ $# -eq 0 ] && is_base_dir "$(pwd)"; then
    ls_filtered_or_exit "$@"

# ls with args
elif [ $# -gt 0 ]; then
    has_dir_arg=false
    for arg in "$@"; do
        if [ -d "$arg" ]; then
            has_dir_arg=true

            # ls with $BASE_DIR as arg
            if is_base_dir "$arg"; then
                ls_filtered_or_exit "$@"
            fi
        fi
    done

    # ls with args in $BASE_DIR
    if [ "$has_dir_arg" = false ] && is_base_dir "$(pwd)"; then
        ls_filtered_or_exit "$@"
    fi
fi

ls "$@"

#!/usr/bin/env bash

BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SILENCE_DEPRECATION_WARNING

# ls wrapper that hides system directories
file_exists "$HOME"/bin/ls.sh && alias ls='$HOME/bin/ls.sh -F --color=auto --group-directories-first'

if file_exists /opt/homebrew/bin/brew; then
    # homebrew environment
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # homebrew completion
    # shellcheck disable=SC1091
    [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

    # homebrew gnu utils
    for d in "$HOMEBREW_PREFIX"/opt/*/libexec/gnubin; do export PATH=$d:$PATH; done
    for d in "$HOMEBREW_PREFIX"/opt/*/libexec/gnuman; do export MANPATH=$d:$MANPATH; done
fi

# macos specific aliases
alias ntl='netstat -na -p TCP | grep -i "listen"'
alias ntlp='netstat -na -p TCP | grep -i "listen" | grep'
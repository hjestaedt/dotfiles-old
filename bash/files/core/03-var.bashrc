#!/usr/bin/env bash

# editor
EDITOR=vim
VISUAL=vim
export EDITOR VISUAL

# history
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:ll:la:cd:pwd:bg:fg:history"
export HISTSIZE HISTFILESIZE HISTCONTROL HISTIGNORE

#!/usr/bin/env bash

# git

if command -v git >/dev/null 2>&1; then

    # git aliases
    alias g='git'
    alias ga='git add'
    alias gaa='git add --all'
    alias gb='git branch'
    alias gba='git branch -a'
    alias gbd='git branch -d'
    alias gbm='git branch -m'
    alias gbr='git branch --remote'
    alias gc='git commit'
    alias gca='git commit --amend'
    alias gcm='git commit -m'
    alias gchb='git checkout -b'
    alias gcho='git checkout'
    alias gd='git diff'
    alias gds='git diff --staged'
    alias gf='git fetch'
    alias gfa='git fetch --all'
    alias gfp='git fetch --prune'
    alias gl='git log'
    alias glg='git log --graph --oneline --decorate --all'
    alias gls='git log --stat'
    alias gp='git push'
    alias gpf='git push --force'
    alias gpl='git pull'
    alias gplr='git pull --rebase'
    alias gr='git rebase'
    alias grb='git rebase -i'
    alias grba='git rebase --abort'
    alias grc='git rebase --continue'
    alias grh='git reset HEAD'
    alias grhh='git reset HEAD --hard'
    alias grma='git remote add'
    alias grmd='git remote rm'
    alias grs='git rebase --skip'
    alias grv='git remote -v'
    alias gs='git status'
    alias gsw='git switch'
    alias gsw-='git switch -'
    alias gswrb='git switch main && git pull && git switch - && git rebase main'
    # git functions

fi
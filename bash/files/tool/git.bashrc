#!/usr/bin/env bash

# git
# https://git-scm.com/docs

if command -v git >/dev/null 2>&1; then

    # git aliases

    # setup/config
    alias g='git'
    alias gcf='git config'
    alias gcfl='git config --local'
    alias gcfg='git config --global'

    # creating projects
    alias gin='git init'
    alias gcl='git clone'

    # basic snapshotting
    alias ga='git add'
    alias ga.='git add .'
    alias gaa='git add --all'
    alias gs='git status'
    alias gdf='git diff'
    alias gdfs='git diff --staged'
    alias gdft='git difftool'
    alias gdfts='git difftool --staged'
    alias gco='git commit'
    alias gcom='git commit -m'
    alias gcoa='git commit -a'
    alias gcoam='git commit -am'
    alias gcox='git commit --amend'
    alias grst='git restore'
    alias grst.='git restore .'
    alias grsts='git restore --staged'
    alias grsts.='git restore --staged .'
    alias gre='git reset'
    alias grem='git reset --mixed'
    alias gres='git reset --soft'
    alias greh='git reset --hard'
    alias grm='git rm'
    alias grmc='git rm --cached'
    alias gmv='git mv'
    alias gno='git notes'

    alias gbr='git branch'
    alias gbrr='git branch --remote'
    alias gbra='git branch -a'
    alias gbrd='git branch -d'
    alias gbrD='git branch -D'
    alias gbrm='git branch -m'


    alias gch='git checkout'
    alias gchb='git checkout -b'

    alias gfe='git fetch'
    alias gfep='git fetch --prune'
    alias gi='git init'
    alias gl='git log'
    alias glo='git log --oneline --decorate -n 10'
    alias gloa='git log --oneline --decorate --all'
    alias glg='git log --graph --oneline --decorate --all'
    alias gls='git log --stat'
    alias gm='git merge'
    alias gps='git push'
    alias gpsf='git push --force'
    alias gpl='git pull'
    alias gplr='git pull --rebase'
    alias grb='git rebase'
    alias grbi='git rebase -i'
    alias grba='git rebase --abort'
    alias grbm='git switch main && git pull && git switch - && git rebase main'

    alias grfl='git reflog'
    alias grmta='git remote add'
    alias grmtr='git remote rm'
    alias grmtv='git remote -v'

    alias gsw='git switch'
    alias gsw-='git switch -'
    alias gst='git stash'
    alias gstp='git stash pop'
    alias gsta='git stash apply'
    alias gstl='git stash list'
    alias gstc='git stash clear'
    alias gstd='git stash drop'

    # git functions

fi

#!/usr/bin/env bash

alias fal='alias | grep -i'

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias d+='pushd'
alias d-='popd'

# ls
alias ls='ls --color'
alias l='ls'
alias ll='ls -l'
alias la='ls -la'
alias lt='ls -ltra'
alias l.='ls -d .*'

# safety
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias rm='rm -I --preserve-root'
alias chown='chown --preserve-root'
alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'

# grep
alias grep='grep --color=auto'
alias igrep='grep -i'
alias egrep='grep -E'           # extended regex
alias fgrep='grep -F'           # fixed string

# override default commands
alias top='htop'
alias ping='ping -c 5'
alias df='df -h'
alias du='du -ch'
alias diff='diff --color'

# custom commands
alias cl='clear'
alias h='history'
alias path='echo -e ${PATH//:/\\n}'
alias envgrep='env | grep'
alias hisgrep='history | grep'
alias now='date +"%d-%m-%Y %T"'
alias nowdate='date +"%d-%m-%Y"'
alias nowtime='date +"%T"'
alias sui='sudo -i'
alias sul='sudo su -l'
alias ntl='netstat -ntl'
alias ntlp='netstat -ntlp'
alias lsfn="declare -F | awk '{print \$NF}' | sort | egrep -v '^_'" # print all user defined functions

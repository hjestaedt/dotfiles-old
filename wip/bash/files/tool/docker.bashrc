#!/usr/bin/env bash

# docker

if command -v docker >/dev/null 2>&1; then
    # docker aliases
    alias d='docker'
    alias dco='docker container'
    alias dcx='docker context'
    alias de='docker exec'
    alias dim='docker image'
    alias din='docker inspect'
    alias dl='docker logs'
    alias dn='docker network'
    alias ds='docker system'
    alias dv='docker volume'
    alias dr='docker run'
    alias dspa='docker system prune -a'
    alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"'
    alias dpsl='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'

    # docker functions
fi

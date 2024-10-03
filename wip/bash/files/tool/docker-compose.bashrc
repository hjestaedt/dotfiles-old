#!/usr/bin/env bash

if command -v docker-compose >/dev/null 2>&1; then

    # docker-compose aliases

    alias doco='docker-compose'
    alias docost='docker-compose start'
    alias docoru='docker-compose run'
    alias docodo='docker-compose down'
    alias docobu='docker-compose build'
    alias docops='docker-compose ps'
    alias docolog='docker-compose log'

    
    # docker-compose functions

fi

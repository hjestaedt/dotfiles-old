#!/usr/bin/env bash

# starship
command_exists starship && eval "$(starship init bash)"
# thefuck
command_exists thefuck && eval "$(thefuck --alias)"
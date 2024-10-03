#!/usr/bin/env bash

# starship
command_exists starship && eval "$(starship init bash)"
# thefuck
command_exists thefuck && eval "$(thefuck --alias)"

# functions
difftool() {
    # shellcheck disable=SC2068
    /Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea diff $@ &>/dev/null
}

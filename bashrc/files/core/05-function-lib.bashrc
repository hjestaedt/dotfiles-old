#!/usr/bin/env bash

# description:
#   check if variable is set
# arguments:
#   variable - variable to check
# returns:
#   0 - variable is set
#   1 - variable is not set
# usage:
#   variable_set <variable>
variable_set() {
    [ -n "$1" ]
}

# description:
#   check if variable is not set
# arguments:
#   variable - variable to check
# returns:
#   0 - variable is not set
#   1 - variable is set
# usage:
#   variable_not_set <variable>
variable_not_set() {
    [ -z "$1" ]
}

# description:
#   exit with error code (and an optional error message)
# arguments:
#   optional: message - error message
# returns:
#   1
# usage:
#   exit_error [message]
exit_error() {
    variable_set "$1" && echo "error: $1" 1>&2
    exit 1
}

# description:
#   check if command exists
# arguments:
#   command - command to check
# returns:
#   0 - command exists
#   1 - command does not exist
# usage:
#   command_exists <command>
#   e.g.: command_exists git
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# description:
#   check if file exists
# arguments:
#   file - file to check
# returns:
#   0 - file exists
#   1 - file does not exist
# usage:
#   file_exists <file>
#   e.g.: file_exists ~/.bashrc
file_exists() {
    [ -f "$1" ]
}
#!/usr/bin/env bash

init_bashrc() {
    variable_set "$BASHRC_HOME" || exit_error "\$BASHRC_HOME must be set"
    for file in "$BASHRC_HOME"/*.bashrc; do
      # shellcheck disable=SC1090
      . "$file"
    done
}

# description:
#   set terminal tab name
#   if tabname is not provided, the tab name is reset to default
# arguments:
#   tabname - tab name (optional)
# usage:
#   set_tabname [tabname]
#   e.g.: set_tabname foo
#   e.g.: set_tabname
set_tabname() {
    echo -en "\033]0;$1\a"
}

# description:
#   # highlight pattern in the fiven input
# arguments:
#   pattern - pattern to highlight
# usage:
#   highlight <pattern>
#   cat <file> | highlight foo
#   cat <file> | highlight "foo\|bar"
#   cat <file> | highlight "foo\|bar" | less -r
highlight() {
    variable_set "$1" || return_error "pattern argument required"
    local escape
    escape=$(printf '\033')
    local color=31
    sed "s,${1},${escape}[${color}m&${escape}[0m,g"
}

# description:
#   encode string to base64
# arguments:
#   string - string to encode
# usage:
#   b64enc <string>
#   b64enc foo
b64enc() {
    variable_set "$1" || return_error "string argument required"
    echo -n "$1" | base64
}

# description:
#   decode base64 string
# arguments:
#   string - string to decode
# usage:
#   b64dec <string>
#   b64dec Zm9v
b64dec() {
    variable_set "$1" || return_error "string argument required"
    echo -n "$1" | base64 -d
}

# description:
#   encrypt file
# arguments:
#   file - file to encrypt
# usage:
#   fencrypt <file>
#   fencrypt foobar.txt
fencrypt() {
    variable_set "$1" || return_error "file argument required"
    openssl enc -aes-256-cbc -e -pbkdf2 -iter 10000 -in "$1" -out "$1".enc
}

# description:
#   decrypt file
# arguments:
#   file - file to decrypt
# usage:
#   fdecrypt <file>
#   fdecrypt foobar.txt.enc
fdecrypt() {
    variable_set "$1" || return_error "file argument required"
    openssl enc -aes-256-cbc -d -pbkdf2 -iter 10000 -in "$1" -out "${1%.enc}"
}


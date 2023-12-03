#!/usr/bin/env bash

# enable extended pattern matching features for filename expansion.
shopt -s extglob

# prevent accidental overwrites with redirection (use >| to force overwriting)
set -o noclobber

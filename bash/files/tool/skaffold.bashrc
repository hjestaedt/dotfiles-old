#!/usr/bin/env bash

# skaffold
# https://skaffold.dev/docs/references/cli/

if command -v skaffold >/dev/null 2>&1; then

    # aliases
    alias skb="skaffold build"
    alias skbp="skaffold build --profile"

    alias skren="skaffold render"
    alias skrenp="skaffold render --profile"

    alias skrun="skaffold run"
    alias skrunp="skaffold run --profile"
    alias skrunpp="skaffold run --port-forward --profile"

    alias skdel="skaffold delete"
    alias skdelp="skaffold delete --profile"

    alias skdev="skaffold dev"
    alias skdevp="skaffold dev --profile"
    alias skdevpp="skaffold dev --port-forward --profile"

fi
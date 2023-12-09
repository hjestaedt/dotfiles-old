#!/usr/bin/env bash

# skaffold
# https://skaffold.dev/docs/references/cli/

if command -v skaffold >/dev/null 2>&1; then

    # aliases
    alias sb="skaffold build"
    alias sbp="skaffold build --profile"

    alias sre="skaffold render"
    alias srep="skaffold render --profile"

    alias srn="skaffold run"
    alias srnp="skaffold run --profile"
    alias srnpp="skaffold run --port-forward --profile"

    alias sd="skaffold dev"
    alias sdp="skaffold dev --profile"
    alias sdpp="skaffold dev --port-forward --profile"
fi
#!/usr/bin/env bash

export CE_DEV_NAMESPACE="airlift-local-dev"
export CE_ENV_RX_LOCAL="ce-rx-dev"
export CE_ENV_RX_DEV="ce-rx-dev"
export CE_ENV_RX_STG="ce-rx-stg"

ce_ns() {
    if [ -z "$1" ]; then
        echo "namespace argument required" 1>&2
        return 1
    fi
    "$HOME"/bin/ce_chns.sh -n "$1" -f "$BASHRC_HOME"/profile/work/ce.bashrc
    # shellcheck source=/dev/null
    . "$BASHRC_HOME"/init.bashrc

    echo
    echo "current namespace: $(kubectl config view --minify --output 'jsonpath={..namespace}')"
    echo "current ce namespace: $(env | grep CE_DEV_NAMESPACE)"
}

ce_env() {
    # parse the first arg for local, dev, stg
    if [ -z "$1" ]; then
        echo "environment argument required" 1>&2
        return 1
    fi
    case "$1" in
        local)
        kubectl config use-context $CE_ENV_RX_LOCAL
        ce_ns "airlift-local-dev"
        ;;
        dev)
        kubectl config use-context $CE_ENV_RX_DEV
        ce_ns "airlift"
        ;;
        stg)
        kubectl config use-context $CE_ENV_RX_STG
        ce_ns "airlift"
        ;;
        *) echo "invalid environment" 1>&2; return 1;;
    esac
}
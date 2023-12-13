#!/usr/bin/env bash

export CE_DEV_NAMESPACE="airlift-local-dev"

NAMESPACE_ENV_VAR="CE_DEV_NAMESPACE"
SHELL_CONFIG="$BASHRC_HOME"/profile/work/flyr.bashrc

declare -A CONFIG_LAB
CONFIG_LAB["context"]="prj-lab"
CONFIG_LAB["namespace"]="default"
CONFIG_LAB["registry"]="europe-west3-docker.pkg.dev/prj-lab-holger-jestaedt/prj-lab-repository"

declare -A CONFIG_RX_HJESTAEDT
CONFIG_RX_HJESTAEDT["context"]="ce-rx-dev"
CONFIG_RX_HJESTAEDT["namespace"]="hjestaedt-local-dev"
CONFIG_RX_HJESTAEDT["registry"]="europe-docker.pkg.dev/prj-flyr-dev-registry/registry"

declare -A CONFIG_RX_LOCAL
CONFIG_RX_LOCAL["context"]="ce-rx-dev"
CONFIG_RX_LOCAL["namespace"]="airlift-local-dev"
CONFIG_RX_LOCAL["registry"]="europe-docker.pkg.dev/prj-flyr-dev-registry/registry"

declare -A CONFIG_RX_DEV
CONFIG_RX_DEV["context"]="ce-rx-dev"
CONFIG_RX_DEV["namespace"]="airlift"
CONFIG_RX_DEV["registry"]="europe-docker.pkg.dev/prj-flyr-dev-registry/registry"

declare -A CONFIG_RX_STG
CONFIG_RX_STG["context"]="ce-rx-stg"
CONFIG_RX_STG["namespace"]="airlift"
CONFIG_RX_STG["registry"]="europe-docker.pkg.dev/prj-flyr-dev-registry/registry"

change_env() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo "context, namespace and registry arguments required" 1>&2
        return 1
    fi

    kubectl config use-context "$1" 1>/dev/null
    kubectl config set-context --current --namespace "$2" 1>/dev/null
    skaffold config set default-repo "$3" 1>/dev/null
}

change_ce_namespace() {
    if [ -z "$1" ]; then
        echo "namespace argument required" 1>&2
        return 1
    fi
    if grep -Fq "$NAMESPACE_ENV_VAR" "$SHELL_CONFIG"; then
        sed -i "s/^export $NAMESPACE_ENV_VAR=.*/export $NAMESPACE_ENV_VAR=\"$1\"/" "$SHELL_CONFIG"
    fi
    # shellcheck source=/dev/null
    . "$BASHRC_HOME"/init.bashrc
}

lsenv() {
    printf "context:\t%s\n" "$(kubectl config current-context)"
    printf "default-repo:\t%s\n" "$(skaffold config list | grep default-repo | awk '{print $2}')"
    printf "namespace:\t%s\n" "$(kubectl config view --minify --output 'jsonpath={..namespace}')"
    printf "ce-namespace:\t%s\n" "$(env | grep CE_DEV_NAMESPACE | awk -F= '{print $2}')"
}

chenv() {
    if [ -z "$1" ]; then
        echo "environment argument required" 1>&2
        return 1
    fi

    case "$1" in
        lab)
            change_env "${CONFIG_LAB["context"]}" "${CONFIG_LAB["namespace"]}" "${CONFIG_LAB["registry"]}"
            change_ce_namespace "none"
            ;;
        ce-hjestaedt)
            change_env "${CONFIG_RX_HJESTAEDT["context"]}" "${CONFIG_RX_HJESTAEDT["namespace"]}" "${CONFIG_RX_HJESTAEDT["registry"]}"
            change_ce_namespace "${CONFIG_RX_HJESTAEDT["namespace"]}"
            ;;
        ce-local)
            change_env "${CONFIG_RX_LOCAL["context"]}" "${CONFIG_RX_LOCAL["namespace"]}" "${CONFIG_RX_LOCAL["registry"]}"
            change_ce_namespace "${CONFIG_RX_LOCAL["namespace"]}"
            ;;
        ce-dev)
            change_env "${CONFIG_RX_DEV["context"]}" "${CONFIG_RX_DEV["namespace"]}" "${CONFIG_RX_DEV["registry"]}"
            change_ce_namespace "${CONFIG_RX_DEV["namespace"]}"
            ;;
        ce-stg)
            change_env "${CONFIG_RX_STG["context"]}" "${CONFIG_RX_STG["namespace"]}" "${CONFIG_RX_STG["registry"]}"
            change_ce_namespace "${CONFIG_RX_STG["namespace"]}"
            ;;
        *)
            echo "invalid environment $1"; return 1;
    esac

    lsenv
}
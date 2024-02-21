#!/usr/bin/env bash

export SKAFFOLD_NAMESPACE="airlift-local-dev"
NAMESPACE_ENV_VAR="SKAFFOLD_NAMESPACE"
export SKAFFOLD_TENANT="rx"
TENANT_ENV_VAR="SKAFFOLD_TENANT"

SHELL_CONFIG="$BASHRC_HOME"/profile/work/flyr.bashrc

declare -A CONFIG_LAB
CONFIG_LAB["name"]="lab"
CONFIG_LAB["context"]="prj-lab"
CONFIG_LAB["namespace"]="default"
CONFIG_LAB["registry"]="europe-west3-docker.pkg.dev/prj-lab-holger-jestaedt/prj-lab-repository"

declare -A CONFIG_RX_HJESTAEDT
CONFIG_RX_HJESTAEDT["name"]="rx-hjestaedt"
CONFIG_RX_HJESTAEDT["context"]="ce-rx-dev"
CONFIG_RX_HJESTAEDT["namespace"]="holger-jestaedt-dev"
CONFIG_RX_HJESTAEDT["registry"]="europe-docker.pkg.dev/prj-flyr-dev-registry/registry"
CONFIG_RX_HJESTAEDT["tenant"]="rx"

declare -A CONFIG_RX_LOCAL
CONFIG_RX_LOCAL["name"]="rx-local"
CONFIG_RX_LOCAL["context"]="ce-rx-dev"
CONFIG_RX_LOCAL["namespace"]="airlift-local-dev"
CONFIG_RX_LOCAL["registry"]="europe-docker.pkg.dev/prj-flyr-dev-registry/registry"
CONFIG_RX_LOCAL["tenant"]="rx"

declare -A CONFIG_RX_DEV
CONFIG_RX_DEV["name"]="rx-dev"
CONFIG_RX_DEV["context"]="ce-rx-dev"
CONFIG_RX_DEV["namespace"]="airlift"
CONFIG_RX_DEV["registry"]="europe-docker.pkg.dev/prj-flyr-dev-registry/registry"
CONFIG_RX_DEV["tenant"]="rx"

declare -A CONFIG_RX_STG
CONFIG_RX_STG["name"]="rx-stg"
CONFIG_RX_STG["context"]="ce-rx-stg"
CONFIG_RX_STG["namespace"]="airlift"
CONFIG_RX_STG["registry"]="europe-docker.pkg.dev/prj-flyr-dev-registry/registry"
CONFIG_RX_STG["tenant"]="rx"

declare -A CONFIG_DEMO_DEV
CONFIG_DEMO_DEV["name"]="demo-dev"
CONFIG_DEMO_DEV["context"]="ce-rx-dev"
CONFIG_DEMO_DEV["namespace"]="airlift-demo"
CONFIG_DEMO_DEV["registry"]="europe-docker.pkg.dev/prj-flyr-dev-registry/registry"
CONFIG_DEMO_DEV["tenant"]="demo"

change_env() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo "context, namespace, registry and tenant arguments required" 1>&2
        return 1
    fi

    kubectl config use-context "$1" 1>/dev/null
    kubectl config set-context --current --namespace "$2" 1>/dev/null
    skaffold config set default-repo "$3" 1>/dev/null
}

change_namespace() {
    if [ -z "$1" ]; then
        echo "namespace argument required" 1>&2
        return 1
    fi
    if grep -Fq "$NAMESPACE_ENV_VAR" "$SHELL_CONFIG"; then
        sed -i "s/^export $NAMESPACE_ENV_VAR=.*/export $NAMESPACE_ENV_VAR=\"$1\"/" "$SHELL_CONFIG"
    fi
}

change_tenant() {
    if [ -z "$1" ]; then
        echo "tenant argument required" 1>&2
        return 1
    fi
    if grep -Fq "$TENANT_ENV_VAR" "$SHELL_CONFIG"; then
        sed -i "s/^export $TENANT_ENV_VAR=.*/export $TENANT_ENV_VAR=\"$1\"/" "$SHELL_CONFIG"
    fi
}

lsenv() {
    printf "kubectl context:\t%s\n" "$(kubectl config current-context)"
    printf "kubectl namespace:\t%s\n" "$(kubectl config view --minify --output 'jsonpath={..namespace}')"
    printf "skaffold default-repo:\t%s\n" "$(skaffold config list | grep default-repo | awk '{print $2}')"
    printf "skaffold namespace:\t%s\n" "$(env | grep SKAFFOLD_NAMESPACE | awk -F= '{print $2}')"
    printf "skaffold tenant:\t%s\n" "$(env | grep SKAFFOLD_TENANT | awk -F= '{print $2}')"
}

chenv() {
    if [ -z "$1" ]; then
        echo "environment argument required" 1>&2
        return 1
    fi

    case "$1" in
        ${CONFIG_LAB["name"]})
            change_env "${CONFIG_LAB["context"]}" "${CONFIG_LAB["namespace"]}" "${CONFIG_LAB["registry"]}"
            change_namespace "${CONFIG_LAB["namespace"]}"
            change_tenant "none"
            ;;
        ${CONFIG_RX_HJESTAEDT["name"]})
            change_env "${CONFIG_RX_HJESTAEDT["context"]}" "${CONFIG_RX_HJESTAEDT["namespace"]}" "${CONFIG_RX_HJESTAEDT["registry"]}"
            change_namespace "${CONFIG_RX_HJESTAEDT["namespace"]}"
            change_tenant "${CONFIG_RX_HJESTAEDT["tenant"]}"
            ;;
        ${CONFIG_RX_LOCAL["name"]})
            change_env "${CONFIG_RX_LOCAL["context"]}" "${CONFIG_RX_LOCAL["namespace"]}" "${CONFIG_RX_LOCAL["registry"]}"
            change_namespace "${CONFIG_RX_LOCAL["namespace"]}"
            change_tenant "${CONFIG_RX_LOCAL["tenant"]}"
            ;;
        ${CONFIG_RX_DEV["name"]})
            change_env "${CONFIG_RX_DEV["context"]}" "${CONFIG_RX_DEV["namespace"]}" "${CONFIG_RX_DEV["registry"]}"
            change_namespace "${CONFIG_RX_DEV["namespace"]}"
            change_tenant "${CONFIG_RX_DEV["tenant"]}"
            ;;
        ${CONFIG_RX_STG["name"]})
            change_env "${CONFIG_RX_STG["context"]}" "${CONFIG_RX_STG["namespace"]}" "${CONFIG_RX_STG["registry"]}"
            change_namespace "${CONFIG_RX_STG["namespace"]}"
            change_tenant "${CONFIG_RX_STG["tenant"]}"
            ;;
        ${CONFIG_DEMO_DEV["name"]})
            change_env "${CONFIG_DEMO_DEV["context"]}" "${CONFIG_DEMO_DEV["namespace"]}" "${CONFIG_DEMO_DEV["registry"]}"
            change_namespace "${CONFIG_DEMO_DEV["namespace"]}"
            change_tenant "${CONFIG_DEMO_DEV["tenant"]}"
            ;;
        *)
            echo "invalid environment $1"; return 1;
    esac

    # shellcheck source=/dev/null
    . "$BASHRC_HOME"/init.bashrc
    lsenv
}
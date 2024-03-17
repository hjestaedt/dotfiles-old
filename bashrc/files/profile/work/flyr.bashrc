#!/usr/bin/env bash

# export SKAFFOLD_NAMESPACE=""
# NAMESPACE_ENV_VAR="SKAFFOLD_NAMESPACE"

SHELL_CONFIG="$BASHRC_HOME"/profile/work/flyr.bashrc
ENVIRONMENT_CONFIG="$BASHRC_HOME"/profile/work/environment.json

change_kube_env() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo "context, namespace, registry and tenant arguments required" 1>&2
        return 1
    fi

    # context
    kubectl config use-context "$1" 1>/dev/null
    # default namespace
    kubectl config set-context --current --namespace "$2" 1>/dev/null
    # skaffold default-repo
    skaffold config set default-repo "$3" 1>/dev/null
}

# update_namespace() {
#     if [ -z "$1" ]; then
#         echo "namespace argument required" 1>&2
#         return 1
#     fi
#     if grep -Fq "$NAMESPACE_ENV_VAR" "$SHELL_CONFIG"; then
#         sed -i "s/^export $NAMESPACE_ENV_VAR=.*/export $NAMESPACE_ENV_VAR=\"$1\"/" "$SHELL_CONFIG"
#     fi
# }

ls_kube_env() {
    printf "kubectl context:\t%s\n" "$(kubectl config current-context)"
    printf "kubectl namespace:\t%s\n" "$(kubectl config view --minify --output 'jsonpath={..namespace}')"
    printf "skaffold default-repo:\t%s\n" "$(skaffold config list | grep default-repo | awk '{print $2}')"
#     printf "skaffold namespace:\t%s\n" "$(env | grep SKAFFOLD_NAMESPACE | awk -F= '{print $2}')"
}

ch_kube_env() {
    if [ -z "$1" ]; then
        echo "environment argument required" 1>&2
        return 1
    fi

    config=$(jq ".[] | select(.id==\"$1\")" "$ENVIRONMENT_CONFIG")
    if [ -z "$config" ]; then
        echo "environment $1 not found" 1>&2
        return 1
    fi

    _context=$(echo "$config" | jq -r '.context')
    _namespace=$(echo "$config" | jq -r '.namespace')
    _registry=$(echo "$config" | jq -r '.registry')

    change_kube_env "$_context" "$_namespace" "$_registry"
#     update_namespace "$_namespace"

    # shellcheck source=/dev/null
    . "$BASHRC_HOME"/init.bashrc
    ls_kube_env
}

# aliases
alias airlift-mvn-cache='docker run --rm -it -v maven-cache:/mnt alpine sh'

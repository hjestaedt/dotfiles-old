#!/usr/bin/env bash

# kubectl
# - https://kubernetes.io/docs/reference/kubectl/cheatsheet/

if command -v kubectl >/dev/null 2>&1; then

    # bash completion
    # shellcheck disable=SC1090
    source <(kubectl completion bash)

    # kubectl aliases

    alias k='kubectl'
    alias ka='kubectl apply'
    alias kaf='kubectl apply -f'
    alias kak='kubectl apply -k'
    alias kk='kubectl kustomize'
    alias kc='kubectl create'
    alias kg='kubectl get'
    alias kl='kubectl logs'
    alias klf='kubectl logs -f'
    alias kdx='kubectl delete'
    alias kdxf='kubectl delete -f'
    alias kdxk='kubectl delete -k'
    alias kde='kubectl describe'
    alias kex='kubectl exec'
    alias kpf='kubectl port-forward'
    alias kcfg='kubectl config'

    alias kge='kubectl get events --sort-by=.metadata.creationTimestamp'
    alias kgew='kubectl get events --sort-by=.metadata.creationTimestamp --watch'

    alias kga='kubectl get all'
    alias kgar='kubectl get all,cm,secret,ing'
    alias kdxa='kubectl delete all --all'

    alias kgp='kubectl get pod'
    alias kdep='kubectl describe pod'
    alias kdxp='kubectl delete pod'
    alias wkgp='watch -n 1 kubectl get pod'

    alias kgd='kubectl get deployment'
    alias kded='kubectl describe deployment'
    alias kdxd='kubectl delete deployment'

    alias kgsvc='kubectl get service'
    alias kdesvc='kubectl describe service'
    alias kdxsvc='kubectl delete service'

    alias kging='kubectl get ingress'
    alias kdeing='kubectl describe ingress'
    alias kdxing='kubectl delete ingress'

    alias kgsec='kubectl get secret'
    alias kdesec='kubectl describe secret'
    alias kdxsec='kubectl delete secret'

    alias kgexsec='kubectl get externalsecret'
    alias kdexsec='kubectl describe externalsecret'
    alias kdxexsec='kubectl delete externalsecret'

    alias kgcm='kubectl get configmap'
    alias kdecm='kubectl describe configmap'
    alias kdxcm='kubectl delete configmap'

    alias kgns='kubectl get namespace'
    alias kcns='kubectl create namespace'
    alias kdens='kubectl describe namespace'
    alias kdxns='kubectl delete namespace'

    alias kgn='kubectl get node'
    alias kden='kubectl describe node'
    alias kdxn='kubectl delete node'

    alias kgctx='kubectl config current-context'
    alias kgctxs='kubectl config get-contexts'
    alias ksctx='kubectl config use-context'

    alias kgdns="kubectl config view --minify --output 'jsonpath={..namespace}'"
    alias ksdns='kubectl config set-context --current --namespace'
    alias kdxdns='kubectl config set-context --current --namespace default'

    alias krrd="kubectl rollout restart deployment"

    alias kgpf="ps -ef | grep 'kubectl' | grep 'port-forward' | awk '{print \$(NF-1), \$NF}'"
    alias kdxpfa='pgrep -fi "kubectl.*port-forward" | xargs kill -9'

    # kubectl functions

    # description:
    #   show logs of the running pod that matches the pattern
    # arguments:
    #   pattern - pod name pattern
    # usage:
    #   kctl_log <pattern>
    #   e.g.: kctl_log foo
    kctl_log() {
        if [ -z "$1" ]; then
            echo "pod name pattern argument required" 1>&2;
            return 1
        fi
        local pattern="$1"
        shift
        kubectl logs -f "$(kubectl get pods | tail -n +2 | grep -i running | awk '{print $pattern}' | grep "$pattern")" "$@"
    }

    # description:
    #   show logs of the running pod that matches the pattern, in json format
    # arguments:
    #   pattern - pod name pattern
    # usage:
    #   kctl_log_json <pattern>
    #   e.g.: kctl_log_json foo
    kctl_log_json() {
        if [ -z "$1" ]; then
            echo "pod name pattern argument required" 1>&2
            return 1
        fi
        pattern="$1"
        shift
        kubectl logs -f "$(kubectl get pods | tail -n +2 | grep -i running | awk '{print $pattern}' | grep "$pattern")" "$@" | grep '^{.*}$' | jq -r '.'
    }

    # delete all pods (optional: that match the pattern) with status different than running
    # arguments:
    #   optional: pattern - pod name pattern
    # usage:
    #  kube_cleanup_pods [pattern]
    #  e.g.: kube_cleanup_pods
    kctl_cleanup_pods() {
        if [ -n "$1" ]; then
            for p in $(kubectl get pods | tail -n +2 | grep -vi running | awk '{print $1}' | grep "$1" ); do
                kubectl delete pod --grace-period=0 "$p"
            done
        else
            for p in $(kubectl get pods | tail -n +2 | grep -vi running | awk '{print $1}'); do
                kubectl delete pod --grace-period=0 "$p"
            done
        fi
    }

    # set up port-forwarding for service that matches the pattern (in a loop, to reconnect after timeout)
    # arguments:
    #   pattern - service name pattern
    #   port-mapping - port mapping in the form [<local-port>:]<remote-port>
    # usage:
    #   kube_port_forward <pattern> <port-mapping>
    #   e.g.: kube_port_forward foo-service 8080:80
    kctl_port_forward() {
        if [ -z "$1" ]; then
            echo "service name pattern argument required" 1>&2
            return 1
        fi
        if [ -z "$2" ]; then
            echo "port-mapping argument required" 1>&2
            return 1
        fi

        service="$(kubectl get service | tail -n +2 | awk '{print $1}' | grep "$1")"

        if [ -z "$service" ]; then
            echo "no service matched the pattern" 1>&2
            return 1
        fi
        if [ "$(echo "$service" | wc -l)" -gt 1 ]; then
            echo "more than one service matched the pattern" 1>&2
            return 1
        fi

        while true; do kubectl port-forward svc/"$service" "$2"; done
    }

    # decode secrets that match the pattern
    # arguments:
    #   pattern - secret name pattern
    # usage:
    #   kctl_decode_secret <pattern>
    #   e.g.: kctl_decode_secret foo
    kctl_decode_secret() {
        if [ -z "$1" ]; then
            echo "secret name pattern argument required" 1>&2
            return 1
        fi
        secrets="$(kubectl get secret | tail -n +2 | awk '{print $1}' | grep "$1")"
        for s in $secrets; do
            echo "secret: $s"
            kubectl get secret "$s" -o jsonpath='{.data}' | jq -r '. | map_values(@base64d)'
            echo
        done
    }
fi
#!/usr/bin/env bash

# starship
command_exists starship && eval "$(starship init bash)"
# thefuck
command_exists thefuck && eval "$(thefuck --alias)"

# variables
JAVA_HOME="$HOME/opt/sdk/jdk-17"
DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
JQ_COLORS="0;90:0;39:0;39:0;39:0;32:1;39:1;39:1;34"
export DOCKER_HOST TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE JAVA_HOME JQ_COLORS SHELL_CONFIG

# path
PATH="$JAVA_HOME/bin:$PATH"
PATH="$HOME/opt/cli/build/maven/bin:$PATH"
PATH="$HOME/opt/cli/build/gradle/bin:$PATH"
PATH="$HOME/opt/skd/jdk-17/bin:$PATH"
export PATH

# functions
difftool() {
    # shellcheck disable=SC2068
    /Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea diff $@ &>/dev/null
}

# ce namespace
export CE_DEV_NAMESPACE="airlift-local-dev"
ce_chns() {
    if [ -z "$1" ]; then
        echo "namespace argument required" 1>&2
        return 1
    fi
    $HOME/bin/ce_chns.sh -n "$1" -f "$BASHRC_HOME"/profile/work/localhost.bashrc
    . $BASHRC_HOME/init.bashrc

    echo
    echo "current namespace: $(kubectl config view --minify --output 'jsonpath={..namespace}')"
    echo "current ce namespace: $(env | grep CE_DEV_NAMESPACE)"
}
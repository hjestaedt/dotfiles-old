#!/usr/bin/env bash

# starship
command_exists starship && eval "$(starship init bash)"
# thefuck
command_exists thefuck && eval "$(thefuck --alias)"

# path
PATH="$JAVA_HOME/bin:$PATH"
PATH="$HOME/opt/cli/build/maven/bin:$PATH"
PATH="$HOME/opt/cli/build/gradle/bin:$PATH"
export PATH

# variables
DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
JAVA_HOME="$HOME/opt/sdk/jdk-17"
JQ_COLORS="0;90:0;39:0;39:0;39:0;32:1;39:1;39:1;34"
CE_DEV_NAMESPACE="hjestaedt-dev"
export DOCKER_HOST TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE JAVA_HOME JQ_COLORS CE_DEV_NAMESPACE

# functions
difftool() {
    # shellcheck disable=SC2068
    /Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea diff $@ &>/dev/null
}
#!/usr/bin/env bash

# gcloud

if command -v gcloud >/dev/null 2>&1; then
    # gcloud aliases
    alias gcl="gcloud"
    alias gclcfga='gcloud config configurations activate'
    alias gclkcred='gcloud container clusters get-credentials'

    # gcloud functions
fi
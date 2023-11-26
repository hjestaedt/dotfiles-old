#!/usr/bin/env bash

# gcloud

if command -v gcloud >/dev/null 2>&1; then
    # gcloud aliases
    alias gc="gcloud"
    alias gccfga='gcloud config configurations activate'
    alias gckcred='gcloud container clusters get-credentials'

    # gcloud functions
fi
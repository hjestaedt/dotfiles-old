#!/usr/bin/env bash

# terraform

if command -v kubectl >/dev/null 2>&1; then
    # alias
    alias tf="terraform"
    alias tfi="terraform init"
    alias tfa="terraform apply"
    alias tfd="terraform destroy"
    alias tff="terraform fmt -recursive -diff -no-color"
    alias tfp="terraform plan"
    alias tfs="terraform show"
fi
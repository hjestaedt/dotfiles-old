#!/bin/bash

yaml_file="home-directory-hierarchy.yaml"
base_dir="$HOME"

yq -r '.[] | .path' "$yaml_file" | while read -r dir; do
    mkdir -p "$base_dir"/"$dir" && chmod 700 "$base_dir"/"$dir"
done

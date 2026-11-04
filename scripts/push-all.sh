#!/bin/bash

# Push all images to the registry

DIRECTORIES=(
    "base/generic"
    "base/node-18"
    "base/node-25"
    "base/node-26"
    "base/wordpress-php8"
    "base/wpcli-php8"
)

for DIRECTORY in "${DIRECTORIES[@]}"; do
    echo "Pushing $DIRECTORY..."
    make -C $DIRECTORY push
    echo "Pushed $DIRECTORY successfully!"
    echo "-------------------------------------------------------"
done

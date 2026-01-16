#!/bin/bash

# Push all images to the registry

DIRECTORIES=(
    "base/generic"
    "base/node-18"
    "base/node-25"
    "workspaces/library-instance-protection"
    "workspaces/library-psr-container"
    "workspaces/library-publishpress-translator"
    "workspaces/library-tooltips"
    "workspaces/library-version-loader-generator"
    "workspaces/library-wordpress-banners"
    "workspaces/library-wordpress-edd-license"
    "workspaces/library-wordpress-reviews"
    "workspaces/library-wordpress-version-notices"
    "workspaces/publishpress-authors"
    "workspaces/publishpress-authors-pro"
    "workspaces/publishpress-blocks"
    "workspaces/publishpress-blocks-pro"
    "workspaces/publishpress-capabilities"
    "workspaces/publishpress-capabilities-pro"
    "workspaces/publishpress-checklists"
    "workspaces/publishpress-checklists-pro"
    "workspaces/publishpress-future"
    "workspaces/publishpress-future-pro"
    "workspaces/publishpress-hub"
    "workspaces/publishpress-permissions"
    "workspaces/publishpress-permissions-pro"
    "workspaces/publishpress-planner"
    "workspaces/publishpress-planner-pro"
    "workspaces/publishpress-revisions"
    "workspaces/publishpress-revisions-pro"
    "workspaces/publishpress-series"
    "workspaces/publishpress-series-pro"
    "workspaces/publishpress-statuses"
    "workspaces/publishpress-statuses-pro"
)

for DIRECTORY in "${DIRECTORIES[@]}"; do
    echo "Pushing $DIRECTORY..."
    make -C $DIRECTORY push
    echo "Pushed $DIRECTORY successfully!"
    echo "-------------------------------------------------------"
done

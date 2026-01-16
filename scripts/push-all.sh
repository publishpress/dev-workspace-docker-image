#!/bin/bash

# Push all images to the registry

DIRECTORIES=(
    "base/generic"
    "base/node-18"
    "base/node-25"
    "library-instance-protection"
    "library-psr-container"
    "library-publishpress-translator"
    "library-tooltips"
    "library-version-loader-generator"
    "library-wordpress-banners"
    "library-wordpress-edd-license"
    "library-wordpress-reviews"
    "library-wordpress-version-notices"
    "publishpress-authors"
    "publishpress-authors-pro"
    "publishpress-blocks"
    "publishpress-blocks-pro"
    "publishpress-capabilities"
    "publishpress-capabilities-pro"
    "publishpress-checklists"
    "publishpress-checklists-pro"
    "publishpress-future"
    "publishpress-future-pro"
    "publishpress-hub"
    "publishpress-permissions"
    "publishpress-permissions-pro"
    "publishpress-planner"
    "publishpress-planner-pro"
    "publishpress-revisions"
    "publishpress-revisions-pro"
    "publishpress-series"
    "publishpress-series-pro"
    "publishpress-statuses"
    "publishpress-statuses-pro"
)

for DIRECTORY in "${DIRECTORIES[@]}"; do
    echo "Pushing $DIRECTORY..."
    make -C $DIRECTORY push
    echo "Pushed $DIRECTORY successfully!"
    echo "-------------------------------------------------------"
done

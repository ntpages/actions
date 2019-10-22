#!/usr/bin/env bash

set -e

argocd_app_delete() {
    preprocess_manifest "$1"

    app=$(oq -r -i yaml .metadata.name .argocd.yml.dist)
    echo "Application name \"$app\" extracted from manifest"

    echo "Delete application \"$app\" from ArgoCD"

    argocd app delete "$app"
}

preprocess_manifest() {
    manifest=${1:-.argocd.yml}

    if [ ! -f "$manifest" ]; then
        echo "ArgoCD application manifest \"$manifest\" not found."
        exit 0;
    fi

    echo "Generate ArgoCD application manifest from \"$manifest\""

    gomplate -f "$manifest" -o "$manifest".dist
}

main() {
    echo "hipages ArgoCD Wrapper by Enrico Stahn."
    echo ""

    case "$1" in
        '' | '-h' | '--help') usage && exit 0;;
        'app-delete') argocd_app_delete "$2" && exit 0;;
         *) argocd "$@"
            ;;
    esac
}

main "$@"
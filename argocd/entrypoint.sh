#!/usr/bin/env bash

set -e

argocd_app_delete() {
    preprocess_manifest "$1"

    app=$(oq -r -i yaml .metadata.name .argocd.yml.dist)
    echo "Application name \"$app\" extracted from manifest"

    echo "Delete application \"$app\" from ArgoCD"

    argocd app delete "$app"
}

argocd_app_deploy() {
  preprocess_manifest "$1"

  app=$(oq -r -i yaml .metadata.name .argocd.yml.dist)
    echo "Application name \"$app\" extracted from manifest"

  argocd app create -f .argocd.yml.dist --upsert
  argocd app wait $app --timeout 240

}

preprocess_manifest() {
    manifest=${1:-.argocd.yml}

    if [ ! -f "$manifest" ]; then
        echo "ArgoCD application manifest \"$manifest\" not found."
        exit 0;
    fi

    echo "Generate ArgoCD application manifest from \"$manifest\""

    repo=$(jq -r .repository.name "$GITHUB_EVENT_PATH")

		TOOLS_TAG=$GIT_SHA1_SHORT \
		KUBE_CHANGE_CAUSE="Build: $GITHUB_RUN_NUMBER, Commit: $GIT_SHA1_SHORT, User: $GITHUB_ACTOR" \
    GIT_REPONAME=$repo gomplate -f "$manifest" -o "$manifest".dist
}

main() {
    echo "hipages ArgoCD Wrapper by Enrico Stahn."
    echo ""

    case "$1" in
        '' | '-h' | '--help') usage && exit 0;;
        'app-delete') argocd_app_delete "$2" && exit 0;;
        'app-deploy') argocd_app_deploy "$2" && exit 0;;
         *) argocd "$@"
            ;;
    esac
}

main "$@"

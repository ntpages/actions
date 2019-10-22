ARG ARGOCD_VERSION=1.3.0-rc1
ARG GOMPLATE_VERSION=3.5.0

FROM argoproj/argocd:v${ARGOCD_VERSION} AS argocd
FROM hairyhenderson/gomplate:v${GOMPLATE_VERSION}-slim as gomplate
FROM stedolan/jq AS jq

FROM debian:buster-slim AS misc
RUN apt-get update && apt-get install -y curl ca-certificates
RUN curl -sSL -o /oq https://github.com/Blacksmoke16/oq/releases/download/v0.2.1/oq-0.2.1-linux-x86_64
RUN chmod 755 /oq

FROM debian:buster-slim

LABEL "com.github.actions.name"="GitHub Action for ArgoCD"
LABEL "com.github.actions.description"="Wraps the ArgoCD CLI to enable common ArgoCD commands."
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="yellow"

LABEL "repository"="https://github.com/hipages/argocd-actions"
LABEL "homepage"="https://github.com/hipages/argocd-actions"

COPY --from=argocd /usr/local/bin/argocd /usr/local/bin/argocd
COPY --from=gomplate /gomplate /usr/local/bin/gomplate
COPY --from=jq /usr/local/bin/jq /usr/local/bin/jq
COPY --from=misc /oq /usr/local/bin/oq
COPY --from=misc /usr/share/ca-certificates /usr/share/ca-certificates
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
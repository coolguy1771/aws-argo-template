#!/bin/bash

# Check if dry-run flag is set
if [ "$1" == "--dry-run" ]; then
    echo "Dry-run flag set"
    DRY_RUN="server"
else
    DRY_RUN="none"
fi

# Set our variables
HELM_REPO_NAME="cilium"
HELM_REPO_SOURCE="https://helm.cilium.io/"
HELM_APP_NAME="cilium"
HELM_APP_VERSION="1.14.5"
HELM_APP_NAMESPACE="kube-system"

# Add the Helm repository
helm repo add ${HELM_REPO_NAME} ${HELM_REPO_SOURCE}
# Update your local Helm chart repository cache
helm repo update
# Template out and install the Helm chart via pipe to `kubectl apply`
helm template ${HELM_APP_NAME} ${HELM_REPO_NAME}/${HELM_APP_NAME} \
--version ${HELM_APP_VERSION} \
--values values.yaml \
-n ${HELM_APP_NAMESPACE} | \
kubectl apply -f - --dry-run=${DRY_RUN}

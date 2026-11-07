#!/usr/bin/env bash

CLUSTER_NAME="iot-cluster"
ARGOCD_MANIFEST="https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
CONF_DIR="/home/vagrant/iot/p3/confs"
NAMESPACES_FILE="$CONF_DIR/namespaces.yml"
APPLICATION_FILE="$CONF_DIR/application.yml"

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

if k3d cluster list 2>/dev/null | awk 'NR>1 {print $1}' | grep -qx "$CLUSTER_NAME"; then
  log "Cluster '$CLUSTER_NAME' already exists"
  log "Starting cluster '$CLUSTER_NAME'..."
  k3d cluster start "$CLUSTER_NAME" >/dev/null 2>&1 || true
else
  log "Creating k3d cluster '$CLUSTER_NAME'"
  k3d cluster create "$CLUSTER_NAME" \
    --agents 2 \
    -p "8888:80@loadbalancer"
fi

kubectl config use-context "k3d-$CLUSTER_NAME" >/dev/null
kubectl wait --for=condition=Ready nodes --all --timeout=180s
kubectl get nodes

log "Creating namespaces (argocd, dev)"
kubectl apply -f "$NAMESPACES_FILE"

log "Installing Argo CD in the argocd namespace"
kubectl apply -n argocd --server-side --force-conflicts -f "$ARGOCD_MANIFEST"
 
log "Waiting for Argo CD to be ready"
kubectl -n argocd rollout status deploy/argocd-server --timeout=300s
kubectl -n argocd rollout status deploy/argocd-repo-server --timeout=300s
kubectl -n argocd rollout status statefulset/argocd-application-controller --timeout=300s

log "Deploying the Argo CD Application"
kubectl apply -f "$APPLICATION_FILE"

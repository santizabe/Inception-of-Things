#!/usr/bin/env bash

set -euo pipefail

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sudo sh
fi

sudo systemctl enable --now docker

if ! id -nG "$USER" | grep -qw docker; then
  sudo usermod -aG docker "$USER"
fi

if ! docker info >/dev/null 2>&1; then
  exec sg docker -c "bash '$0'"
fi

if ! command -v kubectl >/dev/null 2>&1; then
  log "Installing kubectl"
  KUBECTL_VERSION="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
  curl -fsSLo /tmp/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/x86_64/kubectl"
  sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
  rm -f /tmp/kubectl
else
  log "kubectl already installed"
fi

if ! command -v k3d >/dev/null 2>&1; then
  log "Installing k3d"
  curl -fsSL https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | sudo bash
else
  log "k3d already installed"
fi

echo "Docker, kubectl and k3d installed. You may run deploy.sh"

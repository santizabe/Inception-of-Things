#!/bin/bash

set -e

apt update && apt install -y curl

if ! systemctl is-active --quiet k3s; then
    until curl -k https://192.168.56.110:6443 >/dev/null 2>&1; do
        echo "Waiting for k3s server..."
        sleep 5
    done
    curl -sfL https://get.k3s.io | \
        K3S_URL=https://192.168.56.110:6443 \
        K3S_TOKEN=12345 \
        INSTALL_K3S_EXEC="agent --node-ip=192.168.56.111" \
        sh -
fi
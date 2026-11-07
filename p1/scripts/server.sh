#!/bin/bash

set -e

apt-get update && apt-get install -y curl


if ! systemctl is-active --quiet k3s; then
    curl -sfL https://get.k3s.io | sh -s - --token 12345 \
    --node-ip 192.168.56.110 \
    --write-kubeconfig-mode 644 \
    --disable=servicelb \
    --disable=traefik
fi

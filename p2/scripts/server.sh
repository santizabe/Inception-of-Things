#!/bin/bash

set -e

apt update && apt install -y curl

# Write hosts to /etc/hosts

HOSTS_FILE=/etc/hosts
IP=0.0.0.0
domains=(app1.com app2.com app3.com)
MANIFESTS_DIR=/var/lib/rancher/k3s/server/manifests/
resources=(deployments-p2.yml ingress-p2.yml services-p2.yml)

for domain in "${domains[@]}"; do
    # -F: fixed string (no regex), -q: quiet, -x: match the whole line
    if ! fgrep -qx "$(printf '%s\t%s' "$IP" "$domain")" "$HOSTS_FILE"; then
        printf '%s\t%s\n' "$IP" "$domain" >> "$HOSTS_FILE"
    fi
done


[ ! -d $MANIFESTS_DIR ] && \
    mkdir -p /var/lib/rancher/k3s/server/manifests/

for file in "${resources[@]}"; do
    if [[ ! -e "$MANIFESTS_DIR/$file" ]]; then
        cp -- "/vagrant/confs/$file" "$MANIFESTS_DIR/$file"
        echo "Copied $file"
    fi
done


if ! systemctl is-active --quiet k3s; then
    curl -sfL https://get.k3s.io | sh -s - --token 12345 \
    --node-ip 192.168.56.110 \
    --write-kubeconfig-mode 644
fi

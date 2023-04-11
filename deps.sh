#!/bin/bash

function add_helm_repos() {
  helm repo add jetstack https://charts.jetstack.io
  helm repo add grafana https://grafana.github.io/helm-charts
}

function update_os() {
  sudo apt update
  sudo apt upgrade -y
}

function ensure_deps() {
  if command -v yq >/dev/null 2>&1 ; then
    echo "yq is already installed. Skipping."
  else
    wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
    chmod +x /usr/local/bin/yq
  fi

  if command -v helm >/dev/null 2>&1 ; then
    echo "helm is already installed. Skipping."
  else
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    add_helm_repos
  fi

  if command -v prettytable >/dev/null 2>&1 ; then
    echo "prettytable is already installed. Skipping."
  else
    wget https://raw.githubusercontent.com/jakobwesthoff/prettytable.sh/master/prettytable -O /usr/local/bin/prettytable
    chmod +x /usr/local/bin/prettytable
  fi
}

ensure_deps
update_os

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

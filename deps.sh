#!/bin/bash

function add_helm_repos() {
  helm repo add jetstack https://charts.jetstack.io
  helm repo add grafana https://grafana.github.io/helm-charts
}

function update_os() {
  apt update
  apt upgrade -y
  apt install -y curl wget git sudo lsb-release vim
}

function ensure_distro_specific_deps() {
  DISTRO=$(lsb_release -si)
  echo "Detected Distribution: $DISTRO"
  if [[ "$DISTRO" == "Ubuntu" ]]; then
    echo "Disabling ufw"
    ufw disable
    systemctl disable ufw
  elif [[ "$DISTRO" == "Debian" ]]; then
    echo "Updating iptables"
    apt remove -y iptables nftables
    apt install -y arptables ebtables
    update-alternatives --set iptables /usr/sbin/iptables-legacy
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
    update-alternatives --set arptables /usr/sbin/arptables-legacy
    update-alternatives --set ebtables /usr/sbin/ebtables-legacy
  else
    echo "Unsupported Distribution. Exiting..."
    exit 1
  fi
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

update_os
ensure_deps
ensure_distro_specific_deps


export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

#!/bin/bash

. functions.sh

if [ ! -f /etc/rancher/k3s/k3s.yaml ]; then
  echo "k3s not installed. Installing."
  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=$(config_val "k3s.version") INSTALL_K3S_EXEC="--disable=traefik" sh -

  wait_for_resource_rollout deployment metrics-server kube-system
  wait_for_resource_rollout deployment coredns kube-system
  wait_for_resource_rollout deployment local-path-provisioner kube-system
else
  echo "k3s already installed. Skipping."
fi

if [[ "$(config_val 'baseDomain')" == "" ]]; then
  echo "baseDomain is empty. Skipping cert-manager."
else
  echo "baseDomain is not empty. Will install cert-manager and ingress-nginx controller."
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-$(config_val "ingressNginxController.version")/deploy/static/provider/cloud/deploy.yaml
  wait_for_resource_rollout deployment ingress-nginx-controller ingress-nginx

  helm upgrade --install cert-manager jetstack/cert-manager --version $(config_val "certManager.version") --namespace cert-manager --create-namespace --set installCRDs=true

  export EMAIL=$(config_val "email")

  envsubst < manifests/clusterissuer.yaml | kubectl apply -f -

  wait_for_resource_rollout deployment cert-manager cert-manager
  wait_for_resource_rollout deployment cert-manager-webhook cert-manager
  wait_for_resource_rollout deployment cert-manager-cainjector cert-manager
fi

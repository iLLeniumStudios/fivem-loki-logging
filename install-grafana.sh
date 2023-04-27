#!/bin/bash

. functions.sh

kubectl apply -f manifests/dashboards.yaml -n logging

export LOKI_USERNAME=$(config_val "loki.username")
export LOKI_PASSWORD=$(config_val "loki.password")
export GRAFANA_DOMAIN="grafana.$(config_val 'baseDomain')"
export GRAFANA_USERNAME=$(config_val "grafana.username")
export GRAFANA_PASSWORD=$(config_val "grafana.password")

envsubst < value-files/grafana.yaml > value-files/grafana.rendered.yaml

if [[ "$(config_val 'baseDomain')" == "" ]]; then
  helm upgrade --install grafana grafana/grafana --version $(config_val "grafana.version") --namespace logging --values value-files/grafana.rendered.yaml \
	  --set ingress.enabled=false \
	  --set service.type=NodePort \
          --set service.nodePort=$(config_val "grafana.exposedPort")
else
  helm upgrade --install grafana grafana/grafana --version $(config_val "grafana.version") --namespace logging --values value-files/grafana.rendered.yaml
fi

wait_for_resource_rollout deployment grafana logging

rm -rf value-files/grafana.rendered.yaml

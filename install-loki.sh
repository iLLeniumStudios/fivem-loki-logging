#!/bin/bash

. functions.sh

export LOKI_STORAGE=$(config_val "loki.storage")
export LOKI_USERNAME=$(config_val "loki.username")
export LOKI_PASSWORD=$(config_val "loki.password")
export LOKI_DOMAIN="loki.$(config_val 'baseDomain')"
export LOKI_RETENTION=$(config_val "loki.retention")

envsubst < value-files/loki.yaml > value-files/loki.rendered.yaml

if [[ "$(config_val 'baseDomain')" == "" ]]; then
  helm upgrade --install loki grafana/loki --version $(config_val "loki.version") --namespace logging --create-namespace --values value-files/loki.rendered.yaml \
	  --set gateway.ingress.enabled=false \
	  --set gateway.service.type=NodePort \
	  --set gateway.service.nodePort=$(config_val "loki.exposedPort")
else
  helm upgrade --install loki grafana/loki --version $(config_val "loki.version") --namespace logging --create-namespace --values value-files/loki.rendered.yaml
fi


wait_for_resource_rollout statefulset loki logging
wait_for_resource_rollout deployment loki-gateway logging

rm -rf value-files/loki.rendered.yaml

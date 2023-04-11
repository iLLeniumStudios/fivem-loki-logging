#!/bin/bash

function config_val() {
  cat config.yaml | yq -r ".$1"
}

function wait_for_resource() {
  until echo "$(kubectl get $1 -n $3)" | grep -q "$2"; do
    sleep 2
    echo "Waiting for $1/$2 in namespace $3"
done
}

function wait_for_resource_rollout() {
  wait_for_resource $1 $2 $3
  kubectl rollout status $1/$2 -n $3
}

#!/bin/bash

. functions.sh
. deps.sh

./install-k3s.sh
./install-loki.sh
./install-grafana.sh

if [[ "$(config_val 'baseDomain')" == "" ]]; then
  IP=$(ip -f inet addr show eth0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
  LOKI_URL="$IP:$(config_val 'loki.exposedPort')"
  GRAFANA_URL="$IP:$(config_val 'grafana.exposedPort')"
  PROTOCOL="http"
else
  LOKI_URL="loki.$(config_val 'baseDomain')"
  GRAFANA_URL="grafana.$(config_val 'baseDomain')"
  PROTOCOL="https"
fi
{
 printf 'Service\tURL\tUsername\tPassword\n';
 printf '%s\t%s\t%s\t%s\n' "Loki" ${PROTOCOL}://${LOKI_URL} $(config_val "loki.username") $(config_val "loki.password");
 printf '%s\t%s\t%s\t%s\n' "Grafana" ${PROTOCOL}://${GRAFANA_URL} $(config_val "grafana.username") $(config_val "grafana.password");
} | prettytable 4

printf "You can now add the following to your server.cfg in order to configure ox_lib Logger:\n\n"
echo "set ox:logger \"loki\""
echo "set loki:user \"$(config_val 'loki.username')\""
echo "set loki:key \"$(config_val 'loki.password')\""
echo "set loki:protocol \"$PROTOCOL\""
echo "set loki:endpoint \"$LOKI_URL\""

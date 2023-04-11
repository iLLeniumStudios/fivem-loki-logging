#!/bin/bash

. functions.sh
. deps.sh

./install-k3s.sh
./install-loki.sh
./install-grafana.sh

if [[ "$(config_val 'baseDomain')" == "" ]]; then
  IP=$(ip -f inet addr show eth0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
  LOKI_URL="http://$IP:$(config_val 'loki.exposedPort')"
  GRAFANA_URL="http://$IP:$(config_val 'grafana.exposedPort')"
else
  LOKI_URL="https://loki.$(config_val 'baseDomain')"
  GRAFANA_URL="https://grafana.$(config_val 'baseDomain')"
fi
{
 printf 'Service\tURL\tUsername\tPassword\n';
 printf '%s\t%s\t%s\t%s\n' "Loki" $LOKI_URL $(config_val "loki.username") $(config_val "loki.password");
 printf '%s\t%s\t%s\t%s\n' "Grafana" $GRAFANA_URL $(config_val "grafana.username") $(config_val "grafana.password");
} | prettytable 4

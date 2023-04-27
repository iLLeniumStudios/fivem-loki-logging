# fivem-loki-logging
Automated logging setup for FiveM using Loki + Grafana with SSL certificates

<div align='center'><h1><a href='https://docs.illenium.dev/free-resources/fivem-loki-logging/setup'>Documentation</a></h3></div>
<br>

![image](https://user-images.githubusercontent.com/104288623/234932495-71277281-a2e1-4fc5-8ec1-e864ae177543.png)

## Features

- Everything automated and running on Kubernetes
- Loki preconfigured as a Datasource in Grafana
- Retention support
- Loki behind authentication layer
- Pre-configured SSL with valid certificates (if you have a domain)
- Ready to be used with ox_lib

## TL;DR (Only if you know what you're doing)

```bash
git clone https://github.com/iLLeniumStudios/fivem-loki-logging
cd fivem-loki-logging
./install.sh
```

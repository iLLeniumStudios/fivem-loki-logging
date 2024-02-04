### System Requirements
| Resource | Amount |
| :--: | :--: |
| CPU | 2C |
| RAM | 2GB |
| Disk | 64GB |
| OS | Debian 12 |

### Installation

```bash
apt update
apt install git -y
```

```bash
git clone https://github.com/jdbnet/fivem-loki-logging.git
cd fivem-loki-logging
```

Edit config.yaml and add email and passwords

```bash
./install.sh
```

### Ports


| Service     | Port     |
|:----:|:----:|
| Grafana     | 30000     |
| Loki     | 30001     |

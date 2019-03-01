#!/bin/bash
echo "Starting initialization..."

COL='\033[1;36m'
NC='\033[0m' # No Color

configPath=/root/data/config
letsencryptPath=/root/data/letsencrypt
certPath=/root/data/certs
influxDbPath=/srv/docker/influxdb
grafanaPath=/srv/docker/grafana
noderedPath=/srv/docker/nodered
mosquittoPath=/srv/docker/mosquitto

# Create necessary paths
echo "Creating directories..."
mkdir -p $configPath
mkdir -p $letsencryptPath
mkdir -p $certPath
mkdir -p $influxDbPath/data
mkdir -p $grafanaPath/data
mkdir -p $noderedPath/data
mkdir -p $mosquittoPath/config
mkdir -p $mosquittoPath/data
mkdir -p $mosquittoPath/log

# Set owner of Grafana data path to user 472
chown -R 472:472 $grafanaPath
chown -R 1883:1883 $mosquittoPath

# Create files for environment variables if they do not exist.
echo "Creating config files..."
touch $configPath/env.grafana
touch $configPath/env.influxdb
touch $configPath/env.mosquitto
touch $configPath/env.nodered

# Copy HAProxy configuration file to config dir.
cp -n ./haproxy.cfg /root/data/config/haproxy.cfg
cp -n ./mosquitto.conf /root/data/config/mosquitto.conf
cp -n ./nodered_settings.js /root/data/config/nodered_settings.js

# Start docker stack
echo "Starting Docker stack..."
docker-compose up -d --remove-orphans

# General info.
echo ""
echo "Initialization complete."
echo "**************************************************"
echo -e "Grafana path:       ${COL}$grafanaPath${NC}"
echo -e "InfluxDB path:      ${COL}$influxDbPath${NC}"
echo -e "Mosquitto path:     ${COL}$mosquittoPath${NC}"
echo -e "Node-Red path:      ${COL}$noderedPath${NC}"
echo -e "Config path:        ${COL}$configPath${NC}"
echo -e "Let's encrypt path: ${COL}$letsencryptPath${NC}"
echo -e "Certificates path:  ${COL}$certPath${NC}"
echo ""
echo "To set environment variables in Grafana and InfluxDB, use following files:"
echo -e "${COL}$configPath/env.grafana${NC}"
echo -e "${COL}$configPath/env.influxdb${NC}"
echo -e "${COL}$configPath/env.mosquitto${NC}"
echo -e "${COL}$configPath/env.nodered${NC}"
echo ""
echo "For generating SSL certificates for HAProxy, use following example as template:"
echo -e "${COL}sudo docker exec haproxy-certbot certbot-certonly --domain example.com --email user@example.com --dry-run${NC}"
echo ""
echo "Default password for Node-Red is 'password'. For generating new password to use in config file, use the following example as a template:"
echo -e "${COL}sudo docker exec -it nodered node -e \"console.log(require('bcryptjs').hashSync(process.argv[1], 8));\" password${NC}"

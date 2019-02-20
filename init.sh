#!/bin/bash
echo "Starting initialization..."

COL='\033[1;36m'
NC='\033[0m' # No Color

influxDbPath=/srv/docker/influxdb/data
grafanaPath=/srv/docker/grafana/data
configPath=/root/data/config
letsencryptPath=/root/data/letsencrypt
certPath=/root/data/certs

# Create necessary paths
echo "Creating directories..."
mkdir -p $influxDbPath
mkdir -p $grafanaPath
mkdir -p $configPath
mkdir -p $letsencryptPath
mkdir -p $certPath

# Set owner of Grafana data path to user 472
chown 472:472 $grafanaPath

# Create files for environment variables if they do not exist.
echo "Creating config files..."
touch $configPath/env.grafana
touch $configPath/env.influxdb

# Copy HAProxy configuration file to config dir.
cp ./haproxy.cfg /root/data/config/haproxy.cfg

# Start docker stack
echo "Starting Docker stack..."
docker-compose up -d

# General info.
echo ""
echo "Initialization complete."
echo "**************************************************"
echo -e "Grafana path:       ${COL}$grafanaPath${NC}"
echo -e "InfluxDB path:      ${COL}$influxDbPath${NC}"
echo -e "Config path:        ${COL}$configPath${NC}"
echo -e "Let's encrypt path: ${COL}$letsencryptPath${NC}"
echo -e "Certificates path:  ${COL}$certPath${NC}"
echo ""
echo "To set environment variables in Grafana and InfluxDB, please use following files:"
echo -e "${COL}$configPath/env.grafana${NC}"
echo -e "${COL}$configPath/env.influxdb${NC}"
echo ""
echo "For generating SSL certificates for HAProxy, use following example as template:"
echo -e "${COL}sudo docker exec haproxy-certbot certbot-certonly --domain example.com --email user@example.com --dry-run${NC}"
echo ""

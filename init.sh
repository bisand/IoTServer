#!/bin/sh
echo "Starting initialization..."

install_folder="_iotserver"
var="$1"
# remove leading whitespace characters
var="${var#"${var%%[![:space:]]*}"}"
# remove trailing whitespace characters
var="${var%"${var##*[![:space:]]}"}"
if [ ! -z "$var" ]
then
    install_folder=$var
fi

COL='\033[1;36m'
NC='\033[0m' # No Color

config_path=${install_folder}/data/config
letsencrypt_path=${install_folder}/data/letsencrypt
cert_path=${install_folder}/data/certs
influxdb_path=${install_folder}/docker/influxdb
grafana_path=${install_folder}/docker/grafana
nodered_path=${install_folder}/docker/nodered
mosquitto_path=${install_folder}/docker/mosquitto

# Create necessary paths
echo "Creating directories..."
mkdir -p ${config_path}
mkdir -p ${letsencrypt_path}
mkdir -p ${cert_path}
mkdir -p ${influxdb_path}/data
mkdir -p ${grafana_path}/data
mkdir -p ${nodered_path}/data
mkdir -p ${mosquitto_path}/config
mkdir -p ${mosquitto_path}/data
mkdir -p ${mosquitto_path}/log

# Set owner of Grafana data path to user 472
chown -R 472:472 ${grafana_path}
chown -R 1883:1883 ${mosquitto_path}

# Create files for environment variables if they do not exist.
echo "Creating config files..."
touch ${config_path}/env.grafana
touch ${config_path}/env.influxdb
touch ${config_path}/env.mosquitto
touch ${config_path}/env.nodered

# Copy HAProxy configuration file to config dir.
cp -n ./haproxy.cfg ${install_folder}/data/config/haproxy.cfg
cp -n ./mosquitto.conf ${install_folder}/data/config/mosquitto.conf
cp -n ./nodered_settings.js ${install_folder}/data/config/nodered_settings.js

# Start docker stack
echo "Starting Docker stack..."
docker-compose up -d --remove-orphans

# General info.
echo ""
echo "Initialization complete."
echo "**************************************************"
echo -e "Grafana path:       ${COL}${grafana_path}${NC}"
echo -e "InfluxDB path:      ${COL}${influxdb_path}${NC}"
echo -e "Mosquitto path:     ${COL}${mosquitto_path}${NC}"
echo -e "Node-Red path:      ${COL}${nodered_path}${NC}"
echo -e "Config path:        ${COL}${config_path}${NC}"
echo -e "Let's encrypt path: ${COL}${letsencrypt_path}${NC}"
echo -e "Certificates path:  ${COL}${cert_path}${NC}"
echo ""
echo "To set environment variables in Grafana and InfluxDB, use following files:"
echo -e "${COL}${config_path}/env.grafana${NC}"
echo -e "${COL}${config_path}/env.influxdb${NC}"
echo -e "${COL}${config_path}/env.mosquitto${NC}"
echo -e "${COL}${config_path}/env.nodered${NC}"
echo ""
echo "For generating SSL certificates for HAProxy using HTTP challenge, use following example as template:"
echo -e "${COL}sudo docker exec haproxy-certbot certbot-certonly --domain example.com --email user@example.com --dry-run${NC}"
echo ""
echo "For generating SSL certificates for HAProxy using DNS challenge, use following example as template:"
echo -e "${COL}sudo docker exec -it haproxy-certbot certbot-certonly-manual --domain example.com --email user@example.com --dry-run${NC}"
echo ""
echo "Default password for Node-Red is 'password'. For generating new password to use in config file, use the following example as a template:"
echo -e "${COL}sudo docker exec -it nodered node -e \"console.log(require('bcryptjs').hashSync(process.argv[1], 8));\" password${NC}"

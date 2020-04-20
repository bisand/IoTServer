#!/bin/sh
echo "Starting initialization..."

export INSTALL_FOLDER="./_iotserver"

var="$1"
# remove leading whitespace characters
var="${var#"${var%%[![:space:]]*}"}"
# remove trailing whitespace characters
var="${var%"${var##*[![:space:]]}"}"
if [ ! -z "$var" ]
then
    INSTALL_FOLDER=$var
fi

echo "INSTALL_FOLDER=${INSTALL_FOLDER}" > .env

COL='\033[1;36m'
NC='\033[0m' # No Color

HAPROXY_PATH=${INSTALL_FOLDER}/haproxy
MOSQUITTO_PATH=${INSTALL_FOLDER}/mosquitto
INFLUXDB_PATH=${INSTALL_FOLDER}/influxdb
GRAFANA_PATH=${INSTALL_FOLDER}/grafana
NODERED_PATH=${INSTALL_FOLDER}/nodered

# Create necessary paths
echo "Creating directories..."
mkdir -p ${HAPROXY_PATH}/config
mkdir -p ${HAPROXY_PATH}/data
mkdir -p ${HAPROXY_PATH}/certs
mkdir -p ${MOSQUITTO_PATH}/config
mkdir -p ${MOSQUITTO_PATH}/data
mkdir -p ${MOSQUITTO_PATH}/log
mkdir -p ${INFLUXDB_PATH}/config
mkdir -p ${INFLUXDB_PATH}/data
mkdir -p ${INFLUXDB_PATH}/log
mkdir -p ${GRAFANA_PATH}/config
mkdir -p ${GRAFANA_PATH}/data
mkdir -p ${GRAFANA_PATH}/log
mkdir -p ${NODERED_PATH}/data
mkdir -p ${NODERED_PATH}/log

# Set owner of Grafana data path to user 472
chown -R 472:472 ${GRAFANA_PATH}
chown -R 1883:1883 ${MOSQUITTO_PATH}

# Create files for environment variables if they do not exist.
echo "Creating environment variables files..."
touch ${GRAFANA_PATH}/config/env.grafana
touch ${INFLUXDB_PATH}/config/env.influxdb
touch ${MOSQUITTO_PATH}/config/env.mosquitto
touch ${NODERED_PATH}/data/env.nodered

# Copy HAProxy configuration file to config dir.
echo "Copying default config files..."
cp -n ./haproxy.cfg ${HAPROXY_PATH}/config/haproxy.cfg
cp -n ./mosquitto.conf ${MOSQUITTO_PATH}/config/mosquitto.conf
cp -n ./nodered_settings.js ${NODERED_PATH}/data/nodered_settings.js

# Start docker stack
echo "Starting Docker stack..."
docker-compose pull
docker-compose up -d --remove-orphans

# General info.
echo ""
echo "Initialization complete."
echo "**************************************************"
echo "HAProxy path:       ${COL}${HAPROXY_PATH}${NC}"
echo "Mosquitto path:     ${COL}${MOSQUITTO_PATH}${NC}"
echo "Grafana path:       ${COL}${GRAFANA_PATH}${NC}"
echo "InfluxDB path:      ${COL}${INFLUXDB_PATH}${NC}"
echo "Node-Red path:      ${COL}${NODERED_PATH}${NC}"
echo "Certificates path:  ${COL}${HAPROXY_PATH}/certs${NC}"
echo ""
echo "To set environment variables in Grafana and InfluxDB, use following files:"
echo "${COL}${GRAFANA_PATH}/config/env.grafana${NC}"
echo "${COL}${INFLUXDB_PATH}/config/env.influxdb${NC}"
echo "${COL}${MOSQUITTO_PATH}/config/env.mosquitto${NC}"
echo "${COL}${NODERED_PATH}/data/env.nodered${NC}"
echo ""
echo "For generating SSL certificates for HAProxy using HTTP challenge, use following example as template:"
echo "${COL}sudo docker exec haproxy-certbot certbot-certonly --domain example.com --email user@example.com --dry-run${NC}"
echo ""
echo "For generating SSL certificates for HAProxy using DNS challenge, use following example as template:"
echo "${COL}sudo docker exec -it haproxy-certbot certbot-certonly-dns --domain example.com --email user@example.com --dry-run${NC}"
echo ""
echo "Default password for Node-Red is 'password'. For generating new password to use in config file, use the following example as a template:"
echo "${COL}sudo docker exec nodered node -e \"console.log(require('bcryptjs').hashSync(process.argv[1], 8));\" your-password-here${NC}"
echo ""
echo "Apply changes to HAProxy:"
echo "${COL}sudo docker exec haproxy-certbot haproxy-refresh${NC}"
echo ""
echo ""

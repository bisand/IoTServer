mkdir -p /srv/docker/influxdb/data
mkdir -p /srv/docker/grafana/data
mkdir -p /root/data/config
mkdir -p /root/data/config/grafana
mkdir -p /root/data/letsencrypt
mkdir -p /root/data/certs
chown 472:472 /srv/docker/grafana/data
touch /root/data/config/grafana/custom.ini

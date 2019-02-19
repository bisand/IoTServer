# Grafana
You will be able to run a simple TIG (Telegraf, InfluxDB, Grafana) stack in a docker environment.

1. Install Docker (https://www.docker.com/)
2. Install Git (https://git-scm.com/)
3. Clone Git repository: ``` git clone git@github.com:bisand/Grafana.git ```
4. Type: ``` cd Grafana ```
5. Type: ``` sudo ./init.sh ```
6. Type: ``` sudo docker-compose up -d ```

You should be up and running with your TIG stack.

For generating ssl certificates for your web site, please follow the instructions below. For this to work, you will have to point your domain to the server where you have installed the TIG stack.

Generate SSL certificates:
```
sudo docker exec haproxy-certbot certbot-certonly --domain example.com --email user@example.com --dry-run
```

Remember to replace **domain** and **email** with your own, and remove --dry-run when testing is complete.

Make the newly created certificate available to HAProxy:
```
cat /root/data/letsencrypt/archive/example.com/fullchain1.pem /root/data/letsencrypt/archive/example.com/privkey1.pem > /root/data/certs/example.com.pem
```
(Replace example.com with your own domain name)

To apply changes to HAProxy, run following command:
```
sudo docker exec haproxy-certbot haproxy-refresh
```

You should be good to go!

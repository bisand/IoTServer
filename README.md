# IoT Server
You will be able to run a simple IoT server based on Mosquitto, Node-Red, InfluxDB and Grafana in a docker environment. I assume you are running a unix-like OS.

1. Install Docker (https://www.docker.com/)
2. Install Git (https://git-scm.com/)
3. Clone Git repository: ``` git clone git@github.com:bisand/IoTServer.git ```
4. Type: ``` cd IoTServer ``` to enter the newly cloned repository.
5. Type: ``` sudo ./init.sh ``` to initialize and start the docker stack.

You should be up and running with your server stack.

For generating ssl certificates for your web site, please follow the instructions below. For this to work, you will have to point your domain to the server where you have installed the server stack.

### Generate SSL certificates using HTTP challenge:
```sh
sudo docker exec haproxy-certbot certbot-certonly --domain example.com --email user@example.com --dry-run
```

### Generate SSL certificates using manual DNS challenge:
```sh
sudo docker exec -it haproxy-certbot certbot-certonly-manual --domain example.com --email user@example.com --dry-run
```

> Remember to replace **domain** and **email** with your own, and remove --dry-run when testing is complete.

### Apply changes to HAProxy:
```sh
sudo docker exec haproxy-certbot haproxy-refresh
```

You should be good to go!

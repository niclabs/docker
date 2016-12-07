# Node WebAdmin

This dockers brings up a node with it webadmin page

## Quickstart

You just need a recent version (we tested it using the 1.12.1 version) of Docker running in your host machine.

1. To build the dockerfiles and fetch all the dependencies run `./webadmin.sh build`
2. To run a HTTPS server using a self signed certificate run `./webadmin.sh start-https`
3. To stop everything run `./webadmin.sh stop`

## Run modes

- UWSGI Will bring up the node and a UWSGI interface to plug into a server you can choose.

- HTTP Will bring up the node and a HTTP server, this is not intended for production, as the server is uWSGI. You can use this mode to test the server.

- HTTPS This option is intended to provide a production ready server serving only HTTPS, by default it will run with a self-signed certificate.

## Customize my server

- UWSGI by default will not expose the port in the host machine and will only be visibile at the container ip, in order to bind it to the host machine you will need to add this flag: `-p <DESIRED_HOST_PORT>:7787` into the `webadmin/nodeadmin.sh`, in the starthttps function

- HTTP by default it will try to serve at the port 80 of the host machine, you can change the port by changing EXPOSE_HTTP_PORT var at `webadmin/nodeadmin.sh`

- HTTPS is serve by a nginx server using a default configuration, using a provided diffie-hellman parameter and a in-time self signed certificate created in your computer. If you're willing to set the server as you want, all the configuration will be loaded from `nginx/conf/`. if you're not into configuring everything, just set the CN from the server at `nginx/create_cert.sh` before running the server the first time (if you already ran it, just delete `nginx/conf/cert.pem` and `nginx/conf/key.pm`). If you have a certificate you configure it in the conf file and place it at `nginx/conf/`.

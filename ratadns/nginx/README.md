RataDNS / NGINX Docker file
============================

The current folder has the Dockerfiles used to build ratadns-nginxr's image.

It is based on the nginx:latest image and serves /remy as the remy repository, /sse as
gopher reverse proxy.

# How to build

As usual with Dockerfiles run `docker build -t ratadns-remy.` in the same folder
that has the Dockerfile.

# How to run

In order to run the nginx server is needed to have ratadns-gopher running with the hostname
ratadns-gopher (thinking in docker _link_).

If the redis server runs in a container named _redis_, then follow the instructions below:
`
docker run --link ratadns-gopher --name ratadns-nginx -p 8080 -d ratadns-nginx
`

(Don't hesitate using the redis options that you want, such as --restart=unless-stopped or -d)


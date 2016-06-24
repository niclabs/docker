RataDNS / Gopher Docker file
============================

The current folder has the Dockerfiles used to build gopher's image.

It is based on the python:3-slim image and uses gunicorn as WSGI application container
and expose the port 8000 as an http socket.

# How to build

As usual with Dockerfiles run `docker build -t ratadns-gopher .` in the same folder
that has the Dockerfile.

# How to run

In order to run gopher is needed to have a redis server running with the hostname
redis (thinking in docker _link_).

If the redis server runs in a container named _redis_, then follow the instructions below:
`
docker run --link redis --name ratadns-gopher -d ratadns-gopher
`

(Don't hesitate using the redis options that you want, such as --restart=unless-stopped or -d)


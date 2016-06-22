RataDNS / Nginx configuration
=============================

The current folder has the configuration file in order to run Nginx.

# How to run

In order to run the nginx server is needed to have a gopher uwsgi server running with the 
hostname ratadns-gopher (thinking in docker _link_).

If the gopher uwsgi server runs in a container named _ratadns-gopher_, and assuming that your current working directory is
the one of this README, follo the instructions below:
`
docker run --name nginx-ratadns-gopher -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro --link ratadns-gopher -p 8000:80 nginx
`

With the option `-p 8000:80` we are binding the port 80 of the container with the port 8000 of the host machine.

(Don't hesitate using the redis options that you want, such as --restart=unless-stopped or -d)


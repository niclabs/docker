#! /bin/bash

function usage {
    echo "Usage: $0 COMMAND
    Program to manage the server-report containers

    Commands:
    help      Display this message
    delete    Delete docker container for the server
    run				Run docker container for the server
    restart   Start docker container for the server
    stop      Stop docker container for the server
    ";
    exit 1;
}

SERVER_NAME="server-adk"
SERVER_PORT=80

REPORTS_SERVER_NAME="postgres-adk"
REPORTS_SERVER_PORT=8080

NGINX_NAME="nginx-adk"



DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function stop {
    #Stop the aplication
    docker stop $NGINX_NAME
}

function start {
    #start the aplication
    docker start $NGINX_NAME
}

function restart {
    #start the aplication
    delete
		run
}

function delete {
    #Stop application
    stop;
    docker rm -f $NGINX_NAME
}

function run {
	docker run --name $NGINX_NAME -v $(pwd)/nginx.conf:/etc/nginx/conf.d/adk.conf:ro \
		--link $REPORTS_SERVER_NAME:server-report --link $SERVER_NAME:server-adk  \
		-p $SERVER_PORT:$SERVER_PORT $REPORTS_SERVER_PORT:$REPORTS_SERVER_PORT \
		-v /etc/localtime:/etc/localtime:ro  --restart=unless-stopped --log-opt max-size=50m -d nginx
}

### ------------------ Commands and parameter handling ------------------###

case "$1" in
		delete) delete ;;
		run) run ;;
		restart) restart ;;
    stop) stop ;;
    help) usage;;
    *) usage ;;
esac
exit 0;

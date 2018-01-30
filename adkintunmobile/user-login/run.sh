#! /bin/bash

function usage {
    echo "Usage: $0 build | run | start | restart | stop | delete | upgrade";
    exit 1;
}


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function build {
    # build the docker image
    set -e
    docker build --tag login-ws-adk .
}


function run {
    # Run server docker
    port='9090'
    docker run --name login-ws-adk \
    -v $(pwd)/tmp:/usr/src/app/tmp -p $port:1234 \
    -v /etc/localtime:/etc/localtime:ro --restart=unless-stopped \
    -u $(id -u):$(id -g) --log-opt max-size=50m -d login-ws-adk
}

function stop {
    #Stop the aplication
    docker stop login-ws-adk
}


function start {
    #start the aplication
    docker start login-ws-adk
}

function restart {
    #start the aplication
    docker restart login-ws-adk
}


function delete {
    #Stop application and delete all data
    stop;
    docker rm -f login-ws-adk
}


function upgrade {
	delete
	build
	run
}


case "$1" in
    run)
        run
        ;;
    build)
        build
        ;;
    start)
        start
        ;;
    restart)
        restart
        ;;
    stop)
        stop
        ;;
    delete)
        delete
        ;;
    upgrade)
        upgrade
	;;
    *) usage ;;
esac

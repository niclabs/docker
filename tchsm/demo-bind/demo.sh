#!/usr/bin/env bash

usage() { echo "Usage: $0 build | start | stop"; exit 1; }

NODES=3
EXPOSE_PORT=54

DEMO_DIRECTORY_=`dirname $0`
DEMO_DIRECTORY=`readlink -e $DEMO_DIRECTORY_`

function build {

    set -e

    docker build -t tchsm-node-alpine ${DEMO_DIRECTORY}/../node/alpine
    docker build -t tchsm-lib-ubuntu16 ${DEMO_DIRECTORY}/../lib/ubuntu16
    docker build -t tchsm-demo-bind ${DEMO_DIRECTORY}/.
}

function start {

    set -e

    docker network create -d bridge tchsm
    for i in $(seq 1 $NODES)
    do
        docker -D run --net=tchsm -d -v $DEMO_DIRECTORY/conf_files/node$i.conf:/etc/node$i.conf --name node-$i tchsm-node-alpine -c /etc/node$i.conf
    done

    docker create --net=tchsm --name bind-tchsm-demo -p ${EXPOSE_PORT}:53 -p ${EXPOSE_PORT}:53/udp tchsm-demo-bind

    # This will copy the configuration files into the container.
    # We're not using volumes because bind change file permissions.

    docker cp $DEMO_DIRECTORY/conf_files/bind/named.conf.local bind-tchsm-demo:/etc/bind/named.conf.local
    docker cp $DEMO_DIRECTORY/conf_files/bind/named.conf.log bind-tchsm-demo:/etc/bind/named.conf.log
    docker cp $DEMO_DIRECTORY/conf_files/bind/zones/* bind-tchsm-demo:/etc/bind/zones/

    docker exec bind-tchsm-demo /etc/init.d/bind9 restart

    docker start bind-tchsm-demo
}

function stop {

    for i in $(seq 1 $NODES)
    do
        docker rm -f node-$i
    done

    docker rm -f bind-tchsm-demo

    docker network rm tchsm
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    build)
        build
        ;;
    *) usage ;;
esac

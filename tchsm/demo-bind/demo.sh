#!/usr/bin/env bash

usage() { echo "Usage: $0 build | start | stop"; exit 1; }

NODES=3
EXPOSE_PORT=54
WEBMIN_PORT=10001
WEBMIN_PASSWORD=password

DEMO_DIRECTORY_=`dirname $0`
DEMO_DIRECTORY=`readlink -e $DEMO_DIRECTORY_`

function build {

    set -e

    docker build -t tchsm-node-alpine ${DEMO_DIRECTORY}/../node/alpine
    docker build -t tchsm-lib-centos7 ${DEMO_DIRECTORY}/../lib/centos7
    docker build -t tchsm-demo-bind ${DEMO_DIRECTORY}/.
}

function start {

    set -e

    docker network create -d bridge tchsm
    for i in $(seq 1 $NODES)
    do
        docker -D run --net=tchsm -d -v $DEMO_DIRECTORY/conf_files/node$i.conf:/etc/node$i.conf --name node-$i tchsm-node-alpine -c /etc/node$i.conf
    done

    docker -D run --net=tchsm -d -p ${EXPOSE_PORT}:53 -p ${EXPOSE_PORT}:53/udp -p ${WEBMIN_PORT}:10000 -v $DEMO_DIRECTORY/conf_files/bind/etc:/etc/bind --name bind-tchsm-demo tchsm-demo-bind

    docker exec bind-tchsm-demo /bin/bash -c "echo 'root:$WEBMIN_PASSWORD' | chpasswd"
    docker exec bind-tchsm-demo /etc/init.d/webmin start
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

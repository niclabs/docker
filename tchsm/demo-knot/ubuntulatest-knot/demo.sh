#!/usr/bin/env bash

usage() { echo "Usage: $0 build | start | stop"; exit 1; }

NODES=3
EXPOSE_PORT=54

DEMO_DIRECTORY_=`dirname $0`
DEMO_DIRECTORY=`readlink -e $DEMO_DIRECTORY_`

function build {

    set -e

    docker build -t tchsm-node-alpine ${DEMO_DIRECTORY}/../../node/alpine
    docker build -t tchsm-lib-ubuntulatest ${DEMO_DIRECTORY}/../../lib/ubuntulatest
    docker build -t tchsm-demo-ubuntulatest-knot ${DEMO_DIRECTORY}/.
}

function start {

    set -e

    docker network create -d bridge tchsm
    for i in $(seq 1 $NODES)
    do
        docker -D run --net=tchsm -d -v $DEMO_DIRECTORY/conf_files/node$i.conf:/etc/node$i.conf --name node-$i tchsm-node-alpine -c /etc/node$i.conf
    done

    docker create --net=tchsm --name knot-tchsm-demo -p ${EXPOSE_PORT}:53 -p ${EXPOSE_PORT}:53/udp tchsm-demo-ubuntulatest-knot

    # This will copy the configuration files into the container.
    # We're not using volumes because knot change file permissions.
    docker cp $DEMO_DIRECTORY/conf_files/knot knot-tchsm-demo:/root/knot_conf/

    docker start knot-tchsm-demo
}

function stop {

    for i in $(seq 1 $NODES)
    do
        docker rm -f node-$i
    done

    docker rm -f knot-tchsm-demo

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

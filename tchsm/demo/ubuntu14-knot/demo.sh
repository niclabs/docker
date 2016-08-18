#!/usr/bin/env bash


usage() { echo "Usage: $0 start | stop"; exit 1; }

NODES=3

function start {

    # Makes the script fails if some command fails
    set -e

    docker build -t tchsm-node-alpine $(pwd)/../../node/alpine
    docker build -t tchsm-node-alpine $(pwd)/../../lib/ubuntu14
    docker build -t tchsm-demo-ubuntu14-knot .

    docker network create -d bridge tchsm
    for i in $(seq 1 $NODES)
    do
        docker -D run --net=tchsm -d --name node-"$i" -v $(pwd)/conf_files/node$i.conf:/etc/node"$i".conf tchsm-node-alpine:latest -c /etc/node"$i".conf
    done

    docker create --net=tchsm --name knot-tchsm-demo -p 54:53 -p 54:53/udp tchsm-demo-ubuntu14-knot

    # This will copy the configuration files into the container.
    # We're not using volumes because knot change file permissions.
    docker cp $(pwd)/conf_files/knot knot-tchsm-demo:/root/knot_conf/

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
    *) usage ;;
esac

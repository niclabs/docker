#! /usr/bin/env bash

usage () { echo "Usage: $0 build | start | start-https | stop"; exit 1; }
NODEADMIN_DIR_=`dirname $0`
NODEADMIN_DIR=`readlink -e $NODEADMIN_DIR_`

function build {
    set -e

    if [ -f ${NODEADMIN_DIR}/conf/node.conf ];
    then
        echo "node.conf file found, using it"
    else
        echo "node.conf file not found, a new one will be created"
    fi

    docker build -t tchsm-nodeadmin ${NODEADMIN_DIR}/
}

function start {

    docker run -d -v ${NODEADMIN_DIR}/conf:/home/nodeadmin/tchsm-nodeadmin/conf\
               --name tchsm-nodeadmin --net=tchsm-nodeadmin -e "NODEADMIN_HTTP=1"\
               -p 80:80 tchsm-nodeadmin
}

function starthttps {

    docker run -d -v ${NODEADMIN_DIR}/conf:/home/nodeadmin/tchsm-nodeadmin/conf\
               --name tchsm-nodeadmin --net=tchsm-nodeadmin tchsm-nodeadmin
}

function stop {
    set -e

    docker rm -f tchsm-nodeadmin
}

case "$1" in
    stop)
        stop
        ;;
    build)
        build
        ;;
    start)
        start
        ;;
    start-https)
        starthttps
        ;;
    *)
        usage
        ;;
esac

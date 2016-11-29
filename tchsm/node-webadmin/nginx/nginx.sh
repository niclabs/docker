#!/usr/bin/env bash

usage () { echo "Usage: $0 build | start | stop"; exit 1; }

function create_conf_files {
    if [ ! -f ${DIR}/conf/cert.pem ];
    then
        echo "Certificate not found at ${DIR}/conf/cert.pem, creating a new one."
        ${DIR}/create_cert.sh ${DIR}/conf
    fi

    if [ ! -f ${DIR}/conf/dh.pem ];
    then
        echo "Diffie-Hellman parameter not found at ${DIR}/conf/dh.pem, creating a new one."
        echo "This would take a long time, be patient..."
        ${DIR}/create_dh.sh ${DIR}/conf
    fi
}

function start {
    set -e

    DIR_=`dirname $0`
    DIR=`readlink -e $DIR_`

    docker run -d --net=tchsm-nodeadmin -p 443:443 -v ${DIR}/conf:/etc/nginx/conf.d/ --name tchsm-nginx tchsm-nginx



}

function build {
    set -e

    DIR_=`dirname $0`
    DIR=`readlink -e $DIR_`

    create_conf_files

    docker build -t tchsm-nginx ${DIR}
}

function stop {
    docker rm -f tchsm-nginx
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
    *)
        usage
        ;;
esac

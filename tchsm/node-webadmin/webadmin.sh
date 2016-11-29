#!/usr/bin/env bash

usage () { echo "Usage: $0 build | start-http | start-https | start-uwsgi | stop"; exit 1; }

DIR_=`dirname $0`
DIR=`readlink -e $DIR_`

function starthttps {
    set -e

    ${DIR}/webadmin/nodeadmin.sh start-https
    ${DIR}/nginx/nginx.sh start
}

function startuwsgi {
    set -e

    ${DIR}/webadmin/nodeadmin.sh start-https
}

function starthttp {
    set -e
    ${DIR}/webadmin/nodeadmin.sh start
}

function build {
    set -e

    ${DIR}/webadmin/nodeadmin.sh build
    ${DIR}/nginx/nginx.sh build
}

function stop {
    ${DIR}/webadmin/nodeadmin.sh stop
    ${DIR}/nginx/nginx.sh stop 2>/dev/null
}

case "$1" in
    stop)
        stop
        ;;
    build)
        build
        ;;
    start-http)
        starthttp
        ;;
    start-https)
        starthttps
        ;;
    start-uwsgi)
        startuwsgi
        ;;
    *)
        usage
        ;;
esac

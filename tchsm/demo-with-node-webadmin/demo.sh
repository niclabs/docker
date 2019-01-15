#!/usr/bin/env bash

DEMO_DIR_=`dirname $0`
DEMO_DIR=`readlink -e $DEMO_DIR_`
CONF_DIR="${DEMO_DIR}/config_files"

NODES=3

usage() {
	echo "Usage: $0 build | start | stop"
  exit 1
}

function build {
    set -e

    ${DEMO_DIR}/../node-webadmin/webadmin/nodeadmin.sh build
    docker build -t tchsm-lib-ubuntu14 ${DEMO_DIR}/../lib/ubuntu14
    docker build -t tchsm-demo-ubuntu14-knot ${DEMO_DIR}/../demo/ubuntu14-knot

}

function make-config {
	DIR=`pwd`
	cd ${CONF_DIR}
	config_command="python ${CONF_DIR}/create_config.py -db /etc/node -cdb /etc/tchsm-cryptoki"
	for i in $(seq 1 $NODES); do
		config_command+=" node-${i}:$((2120 + 2*i-1)):$((2120 + 2*i))"
		sed "s/node_n/node_${i}/" config_template.py > config_${i}.py
	done
	`$config_command`
	cd ${DIR}
}

function start {
    set -e
    # First check if config files exist
    config_files_exist=true
    for i in $(seq 1 $NODES)
    do
      if [ ! -f "${CONF_DIR}/node${i}.conf" ]; then
				config_files_exist=false
			fi
    done
		if [ ! -f "${CONF_DIR}/cryptoki.conf" ]; then
			config_files_exist=false
		fi

    if [ $config_files_exist = true ]; then
			echo "Config files found, using existing config files"
		else
			echo "Config files not found, creating new ones"
			make-config

    fi

    docker network create -d bridge tchsm

    for i in $(seq 1 $NODES)
	  do
			start-node $((2120 + 2*i-1)) $((2120 + 2*i)) $((8000+i)) "node-$i" "node${i}.conf" "config_${i}.py"
	  done

    docker create --net=tchsm --name knot-tchsm-demo -p ${EXPOSE_PORT}:53 -p ${EXPOSE_PORT}:53/udp tchsm-demo-ubuntu14-knot:latest

    # This will copy the configuration files into the container.
    # We're not using volumes because knot change file permissions.
    docker cp $DEMO_DIR/knot knot-tchsm-demo:/root/knot_conf/
    docker cp $CONF_DIR/cryptoki.conf knot-tchsm-demo:/root/knot_conf/cryptoki.conf

#    docker start knot-tchsm-demo

}

function stop {
    for i in $(seq 1 $NODES)
    do
      	docker rm -f node-$i
    done

    docker rm -f knot-tchsm-demo
    docker network rm tchsm
}

function stop-server {
		docker rm -f knot-tchsm-demo
}

function start-node () {
  EXPOSE_NODE_ROUTER_PORT=$1
  EXPOSE_NODE_SUB_PORT=$2
  EXPOSE_HTTP_PORT=$3
  CONTAINER_NAME=$4
  NODEADMIN_CONF=$5
	NODEADMIN_CONF_PY=$6


  docker run -d -v ${CONF_DIR}/${NODEADMIN_CONF}:/home/nodeadmin/tchsm-nodeadmin/conf/node.conf \
							-v ${CONF_DIR}/start.sh:/home/nodeadmin/tchsm-nodeadmin/conf/start.sh \
							-v ${CONF_DIR}/${NODEADMIN_CONF_PY}:/home/nodeadmin/tchsm-nodeadmin/config.py \
              --name $CONTAINER_NAME --net=tchsm -e "NODEADMIN_HTTP=1" \
              -p 0.0.0.0:${EXPOSE_HTTP_PORT}:80 -p 0.0.0.0:${EXPOSE_NODE_ROUTER_PORT}:${EXPOSE_NODE_ROUTER_PORT} \
              -p 0.0.0.0:${EXPOSE_NODE_SUB_PORT}:${EXPOSE_NODE_SUB_PORT} tchsm-nodeadmin

}

function start-server {
	docker start knot-tchsm-demo
}

case "$1" in
    start)
        start
				;;
    start-server)
        start-server
        ;;
    stop)
        stop
        ;;
    stop-server)
        stop-server
        ;;
    build)
        build
        ;;
    make-config)
        make-config
        ;;
    *) usage ;;
esac

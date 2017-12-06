
NODEADMIN_DIR="/home/felipe/Documents/ejemplo"

NODEADMIN_DIR_=`dirname $0`
NODEADMIN_DIR=`readlink -e $NODEADMIN_DIR_`
NODES=3

function usage {
	echo "Usage: $0 start | stop"
}

function start {
    docker network create -d bridge tchsm
    start-node 2121 2122 8001 "node-1" "${NODEADMIN_DIR}/conf_1"
    start-node 2123 2124 8002 "node-2" "${NODEADMIN_DIR}/conf_2"
    start-node 2125 2126 8003 "node-3" "${NODEADMIN_DIR}/conf_3"
    
    docker create --net=tchsm --name knot-tchsm-demo -p ${EXPOSE_PORT}:53 -p ${EXPOSE_PORT}:53/udp tchsm-demo-ubuntu14-knot:latest

    # This will copy the configuration files into the container.
    # We're not using volumes because knot change file permissions.
    docker cp $NODEADMIN_DIR/knot knot-tchsm-demo:/root/knot_conf/

#    docker start knot-tchsm-demo

}

function stop {
  docker rm -f node-1 node-2 node-3

  docker rm -f knot-tchsm-demo

  docker network rm tchsm
}

function start-node () {
  EXPOSE_NODE_ROUTER_PORT=$1
  EXPOSE_NODE_SUB_PORT=$2
  EXPOSE_HTTP_PORT=$3
  CONTAINER_NAME=$4
  NODEADMIN_CONF_DIR=$5

  docker run -d -v ${NODEADMIN_CONF_DIR}:/home/nodeadmin/tchsm-nodeadmin/conf \
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
    build)
        build
        ;;
    *) usage ;;
esac


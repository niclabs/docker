#!/usr/bin/env bash

END=3

docker build -t tchsm-node-alpine $(pwd)/../../node/alpine
docker build -t tchsm-demo-knot .

docker network create -d bridge tchsm
for i in $(seq 1 $END)
do
    docker run -d --net=tchsm --name node-"$i" -v $(pwd)/conf_files/node$i.conf:/etc/node"$i".conf tchsm-node-alpine:latest -c /etc/node"$i".conf
done

docker run -it --net=tchsm --name knot-tchsm-demo -p 54:53 -v $(pwd)/conf_files/knot:/root/knot_conf/ tchsm-demo-knot

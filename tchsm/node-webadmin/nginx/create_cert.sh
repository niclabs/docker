#!/usr/bin/env bash

if [ $# -eq 0 ]
then
    echo "No output dir supplied, using working directory as output"
    OUT_DIR=`pwd`
else
    OUT_DIR=$1
fi

openssl req -newkey rsa:2048 -sha256 -nodes -keyout ${OUT_DIR}/key.pem -x509 -days 365 -out ${OUT_DIR}/cert.pem -subj "/C=CL/ST=Metropolitana/L=Santiago/O=NICLabsChile/CN=127.0.0.1"

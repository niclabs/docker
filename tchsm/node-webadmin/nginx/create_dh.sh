#!/usr/bin/env bash

if [ $# -eq 0 ]
then
    echo "No output dir supplied, using working directory as output"
    OUT_DIR=`pwd`
else
    OUT_DIR=$1
fi

openssl dhparam -out ${OUT_DIR}/dh.pem 4096

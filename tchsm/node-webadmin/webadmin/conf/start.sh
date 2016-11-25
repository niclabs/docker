#! /usr/bin/env bash

set -e
DIR_=`dirname $0`
DIR=`readlink -e $DIR_`
echo $DIR

if [ ! -f ${DIR}/node.conf ];
then
    create_config.py 127.0.0.1:2121:2222 -o ${DIR}/conf
    ls ${DIR}
    rm ${DIR}/conf/cryptoki.conf
    mv ${DIR}/conf/node1.conf ${DIR}/conf/node.conf
fi

supervisord -c ../supervisor.conf

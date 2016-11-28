#! /usr/bin/env bash

set -e
DIR_=`dirname $0`
DIR=`readlink -e $DIR_`

if [ ! -f ${DIR}/node.conf ];
then
    echo "Configuration not found, creating one..."
    create_config.py 127.0.0.1:2121:2222 -o ${DIR}/conf
    rm ${DIR}/cryptoki.conf
    rm ${DIR}/master.conf
    mv ${DIR}/node1.conf ${DIR}/node.conf
fi

supervisord -c ${DIR}/../supervisor.conf

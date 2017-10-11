#! /bin/bash

function usage { 
    echo "Usage: $0 build | run | start | restart | stop | delete | upgrade"; 
    exit 1;
    }

function usage_run { 
    echo "Usage: $0 run [-u <string : user name> ] [-p <string : password>] [-d <string : database name>]";
    exit 1; 
}


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function build {
    # build the docker images
    set -e

    cd "$DIR/populate"
    docker build --tag populate-adk .
    cd "$DIR/server"
    docker build --tag server-adk .
    cd "$DIR/reports"
    docker build --tag reports-adk .
}


function run {
    # run the docker containers

    args=`getopt -o u:p:d: -- "$@"`
    num=0

    eval set -- "$args"
    while true ; do
        case "$1" in
            -u) u="$2"
                shift 2
                num=$((num+1))
                ;;
            -p) p="$2"
                shift 2
                num=$((num+1))
                ;;
            -d) d="$2" 
                shift 2
                num=$((num+1))
                ;;
            --) shift ; break ;;
            *) usage_run ;;
        esac
    done

    if (($num != 3))
    then
        echo "$num"
        echo "You must use -u, -p and -d!";
        usage_run;
    fi
    
    cd "$DIR"

    # Give as parameter the database name, the user and the password. They must be the same in config.py
    docker run --name postgres-adk -e POSTGRES_PASSWORD=$p -e POSTGRES_USER=$u -e POSTGRES_DB=$d --restart=unless-stopped \
    -p 5432:5432 -v /etc/localtime:/etc/localtime:ro --log-opt max-size=50m -d postgres

    until nc -z $(docker inspect --format='{{.NetworkSettings.IPAddress}}' postgres-adk) 5432
    do
        echo "waiting for postgres container..."
        sleep 0.5
    done
    # Remember change the config.py file before!

    # Run populate docker
    docker run --name populate-adk --link postgres-adk:postgres -v $(pwd)/config.py:/adk/AdkintunMobile-Server/config.py \
    --rm populate-adk
    # Run server docker
    docker run --name server-adk --link postgres-adk:postgres -v $(pwd)/config.py:/adk/AdkintunMobile-Server/config.py \
    -v $(pwd)/tmp:/adk/AdkintunMobile-Server/tmp -v /etc/localtime:/etc/localtime:ro --restart=unless-stopped --log-opt\
    max-size=50m -d server-adk
    # Run reports docker
    docker run --name reports-adk --link postgres-adk:postgres -v $(pwd)/reports/config.py:/adk/adkintun-reports/config.py \
    -v $(pwd)/reports:/adk/adkintun-reports/app/static/reports -v $(pwd)/reports/tmp:/adk/adkintun-reports/tmp \
    -v /etc/localtime:/etc/localtime:ro --restart=unless-stopped --log-opt max-size=50m -d reports-adk
    # Run the nginx server docker
    docker run --name nginx-adk -v $(pwd)/nginx.conf:/etc/nginx/conf.d/adk.conf:ro --link server-adk:server-adk\
    --link reports-adk:reports-adk -p 80:80 -v /etc/localtime:/etc/localtime:ro  --restart=unless-stopped --log-opt\
    max-size=50m -d nginx
}

function stop {
    #Stop the aplication

    docker stop postgres-adk server-adk reports-adk nginx-adk
}


function start {
    #start the aplication

    docker start postgres-adk server-adk reports-adk nginx-adk 
}

function restart {
    #start the aplication

    docker restart postgres-adk server-adk reports-adk nginx-adk 
}


function delete {
    #Stop application and delete all data
    stop;
    docker rm -f postgres-adk server-adk reports-adk nginx-adk
}


function upgrade {
    # delete container server
    docker stop server-adk
    docker rm -f server-adk

    # build container server
    cd "$DIR/server"
    docker build --tag server-adk .

    cd "$DIR"
    # run container
    docker run --name server-adk --link postgres-adk:postgres -v $(pwd)/config.py:/adk/AdkintunMobile-Server/config.py \
    -v $(pwd)/reports:/adk/AdkintunMobile-Server/app/static/reports -v $(pwd)/tmp:/adk/AdkintunMobile-Server/tmp \
    -v /etc/localtime:/etc/localtime:ro --restart=unless-stopped --log-opt max-size=50m -d server-adk

}

case "$1" in
    run)
        run $@
        ;;
    build)
        build
        ;;
    start)
        start
        ;;
    restart)
        restart
        ;;     
    stop)
        stop
        ;;    
    delete)
        delete
        ;;   
    upgrade)
        upgrade
        ;;   
    *) usage ;;
esac




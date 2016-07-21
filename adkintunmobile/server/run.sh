#! /bin/bash

usage() { echo "Usage: $0 [-u <string : user name> ] [-p <string : password>] [-d <string : database name>]"; exit 1; }


args=`getopt -o u:p:d: -- "$@"`
num=0

eval set -- "$args"

while true ; do
    case "$1" in
        -u)
            u="$2"
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
        *) usage ;;
    esac
done

if (($num != 3))
then
    echo "You must use -u, -p and -d!";
    usage;
fi


# Run the database docker
# Give as parameter the database name, the user and the password. They must be the same in config.py
docker run --name postgres-adk -e POSTGRES_PASSWORD=$p -e POSTGRES_USER=$u -e POSTGRES_DB=$d --restart=unless-stopped -p 5432:5432 -d postgres

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Run the populate docker
# Remember change the config.py file before!
cd "$DIR/populate"
docker build --tag populate-adk .
cd "$DIR"
docker run --name populate-adk --link postgres-adk:postgres -v $(pwd)/config.py:/adk/AdkintunMobile-Server/config.py --rm populate-adk


# Run uwsgi docker
cd "$DIR/uwsgi"
docker build --tag uwsgi-adk .
cd "$DIR"
docker run --name uwsgi-adk --link postgres-adk:postgres -v $(pwd)/config.py:/adk/AdkintunMobile-Server/config.py --restart=unless-stopped -d uwsgi-adk


# Run the nginx server docker
cd "$DIR"
docker run --name nginx-adk -v $(pwd)/nginx.conf:/etc/nginx/conf.d/adk.conf:ro --link uwsgi-adk:uwsgi-adk -p 80:80 --restart=unless-stopped -d nginx
#! /bin/bash

usage() { echo "Usage: $0 [-u <string : user name> ] [-p <string : password>] [-d <string : database name>]"; exit 1; }
#Montar docker con la base de datos
#docker run --name postgres-adk -e POSTGRES_PASSWORD=<clave_user> -e POSTGRES_USER=<user> -e POSTGRES_DB=<database_name> -d postgres

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


# Montar docker con la base de datos
# Especificar como variables los valores necesarios para crear la base de datos, su usuario y password
# Estos deben estar también en el archivo de configuración tanto del uwsgi como de populate

docker run --name postgres-adk -e POSTGRES_PASSWORD=$p -e POSTGRES_USER=$u -e POSTGRES_DB=$d --restart=unless-stopped -d postgres

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Correr populate, con configuraciones bien seteadas
cd "$DIR/populate"
docker build --tag populate-adk .
cd "$DIR"
docker run --name populate-adk --link postgres-adk:postgres -v $(pwd)/config.py:/adk/AdkintunMobile-Server/config.py --rm populate-adk


#Correr uwsgi

cd "$DIR/uwsgi"
docker build --tag uwsgi-adk .
cd "$DIR"
docker run --name uwsgi-adk --link postgres-adk:postgres -v $(pwd)/config.py:/adk/AdkintunMobile-Server/config.py --restart=unless-stopped -d uwsgi-adk


#Por último levantar el servidor nginx
cd "$DIR"
docker run --name nginx-adk -v $(pwd)/nginx.conf:/etc/nginx/conf.d/adk.conf:ro --link uwsgi-adk:uwsgi-adk -p 80:80 --restart=unless-stopped -d nginx
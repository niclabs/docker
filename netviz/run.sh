#! /bin/bash

function usage {
    echo "Usage: $0 build | run | start | restart | stop | delete | upgrade | populate | backup | restore";
    exit 1;
    }

function usage_run {
    echo "Usage: $0 run [-u <string : user name> ] [-p <string : password>] [-d <string : database name>]";
    exit 1;
}
function usage_populate {
    echo "Usage: $0 populate [-u <string : user name> ] [-p <string : password>] [-d <string : database name>]";
    exit 1;
}
function usage_backup {
    echo "Usage: $0 backup [-u <string : user name> ] [-p <string : password>] [-d <string : database name>] [-f output file]";
    exit 1;
}
function usage_restore {
    echo "Usage: $0 restore [-u <string : user name> ] [-p <string : password>] [-d <string : database name>] [-f input file]";
    exit 1;
}

function get_options {
    num=0
    args=$1
    shift
    names=()
    for var in $@; do
      names=("${names[@]}" $var)
    done
    eval set -- `$args`
    while true; do
      sleep 1
      for name in ${names[@]}; do
        if [ "$1" = "-$name" ]; then
          local  result=$name
          local  value="$2"
          eval $result="'$value'"
          num=$((num+1))
          shift 2
        fi
      done
      if [ $1 = "--" ]; then
        break;
      fi
    done
    local result="num"
    eval $result="'$num'"
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function build {
    # build the docker images
    set -e

    cd "$DIR/populate"
    docker build --tag populate-nv .
    cd "$DIR/server"
    docker build --tag server-nv .
}


function run {
    # run the docker containers

    args="getopt -o u:p:d: -- $@"
    get_options "$args" u p d
    if (($num != 3))
    then
        echo "You must use -u, -p and -d!";
        usage_run;
    fi

    cd "$DIR"

    # Give as parameter the database name, the user and the password. They must be the same in config.py
    docker run --name postgres-nv -e POSTGRES_PASSWORD=$p -e POSTGRES_USER=$u -e POSTGRES_DB=$d \
      -e PGDATA=/var/lib/postgresql/data/dbdata --restart=unless-stopped  \
      --log-opt max-size=50m --volumes-from dbstore -d mdillon/postgis:9.5
    until docker run --rm --link postgres-nv:postgres mdillon/postgis:9.5 psql --dbname postgresql://$u:${p}@postgres/$d -c "select 1" > /dev/null
    do
        echo "waiting for postgres container..."
        sleep 1
    done
    # Remember change the config.py file before running!

    # Run server docker
    docker run --name server-nv --link postgres-nv:postgres -v $(pwd)/config.py:/netviz/net-viz/config.py \
     --restart=unless-stopped --log-opt max-size=50m -d server-nv
    # Run the nginx server docker
    docker run --name nginx-nv -v $(pwd)/nginx.conf:/etc/nginx/conf.d/app.conf:ro --link server-nv:server-nv \
     -p 80:80 --restart=unless-stopped --log-opt max-size=50m -d nginx
}

function stop {
    #Stop the aplication

    docker stop postgres-nv server-nv nginx-nv
}


function start {
    #start the aplication

    docker start postgres-nv server-nv nginx-nv
}

function restart {
    #restart the aplication

    docker restart postgres-nv server-nv nginx-nv
}


function delete {
    #Stop application and delete all data
    # Backup before doing this!
    stop;
    docker rm -f postgres-nv server-nv nginx-nv
    docker rm -v dbstore
}


function upgrade {
    # delete container server
    docker stop server-nv
    docker rm -f server-nv

    # build container server
    cd "$DIR/server"
    docker build --tag server-nv .

    cd "$DIR"
    # run container
    docker run --name server-nv --link postgres-nv:postgres -v $(pwd)/config.py:/netviz/net-viz/config.py \
     --restart=unless-stopped --log-opt max-size=50m -d server-nv
}


function populate {
    args="getopt -o u:p:d: -- $@"
    num=0
    get_options "$args" u p d
    if (($num != 3))
    then
        echo "You must use -u, -p and -d!";
        usage_populate;
    fi
    docker create -v /var/lib/postgresql/data/dbdata --name dbstore mdillon/postgis:9.5 /bin/true

    docker run --name populate-nv -e POSTGRES_USER=$u -e POSTGRES_DB=$d -e POSTGRES_PASSWORD=$p \
     -e PGDATA=/var/lib/postgresql/data/dbdata --volumes-from dbstore -d populate-nv
    until nc -z $(docker inspect --format='{{.NetworkSettings.IPAddress}}' populate-nv) 5432
    do
        echo "Populating database, this may take several minutes..."
        sleep 5
    done
    docker run --rm --link populate-nv:postgres mdillon/postgis:9.5 \
      psql --dbname postgresql://$u:$p@postgres:5432/$d -c "CREATE DATABASE $u"
    docker rm -f populate-nv
}


function backup {
  # Backup database data into sql file

  args="getopt -o u:p:d:f: -- $@"
  get_options "$args" u p d f
  if (($num != 4))
  then
      echo "You must use -u, -p, -d and -f!";
      usage_backup;
  fi
  docker run --rm -it -v $DIR/backups:/backups --link postgres-nv:postgres mdillon/postgis:9.5 \
   pg_dump --dbname postgresql://$u:$p@postgres:5432/$d -f /backups/$f
}


function restore {
    # Restore the database to a previous state taken from a sql file
    # Backup before doing this!
    echo "restore"
    args="getopt -o u:p:d:f: -- $@"
    get_options "$args" u p d f
    if (($num != 4))
    then
        echo "You must use -u, -p, -d and -f!";
        usage_backup;
    fi
    docker stop server-nv
    docker run --rm --link postgres-nv:postgres mdillon/postgis:9.5 \
      psql --dbname postgresql://$u:$p@postgres:5432/$u -c "DROP DATABASE $d"
    docker run --rm --link postgres-nv:postgres mdillon/postgis:9.5 \
      psql --dbname postgresql://$u:$p@postgres:5432/$u -c "CREATE DATABASE $d"
    docker run --rm --link postgres-nv:postgres -v $DIR:$DIR mdillon/postgis:9.5 \
      psql --dbname postgresql://$u:$p@postgres:5432/$d -f $DIR/$f
    docker start server-nv
}


case "$1" in
    run) run $@ ;;
    build) build ;;
    start) start ;;
    restart) restart ;;
    stop) stop ;;
    delete) delete ;;
    upgrade) upgrade ;;
    populate) populate $@ ;;
    backup) backup $@ ;;
    restore) restore $@ ;;
    *) usage ;;
esac

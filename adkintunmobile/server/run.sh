#! /bin/bash

function usage {
    echo "Usage: $0 COMMAND
    Program to manage the server-report containers

    Commands:
    help      Display this message
    backup    Backup database to file
    build     Build docker images
    delete    Delete docker container for the server
    login     Log into the database
    populate  Populate database with initial data
    rundb     Create and start docker container for database
    runserver Run docker container for the server
    start     Start docker container for the server
    stop      Stop docker container for the server
    upgrade   Rebuild and restart docker container for the  server
    ";
    exit 1;
}

SERVER_NAME="server-adk"
DATABASE_NAME="postgres-adk"

function usage_run {
    echo "Usage: $0 run [-u <string : user name> ] [-p <string : password>] [-d <string : database name>]";
    exit 1;
}


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function rundb () {
  user="$1"
  password="$2"
  # Give as parameter the database name, the user and the password. They must be the same in config.py
  docker run --name $DATABASE_NAME -e POSTGRES_PASSWORD=$p -e POSTGRES_USER=$u \
    -e POSTGRES_DB=adkintunMobile --restart=unless-stopped \
    -v /etc/localtime:/etc/localtime:ro --log-opt max-size=50m -d postgres

  until nc -z $(docker inspect --format='{{.NetworkSettings.IPAddress}}' $DATABASE_NAME) 5432
  do
      echo "waiting for postgres container..."
      sleep 1
  done
}

function build {
    # build the docker images
    set -e

    cd "$DIR/populate"
    docker build --tag populate-adk .
    cd "$DIR/server"
    docker build --tag server-adk .
}


function runserver {
    # Run server docker
    mkdir -p $(pwd)/../report-generation/reports
    mkdir -p $(pwd)/tmp
    docker run --name $SERVER_NAME --link $DATABASE_NAME:postgres -v $(pwd)/config.py:/adk/AdkintunMobile-Server/config.py \
    -v $(pwd)/../report-generation/reports:/adk/AdkintunMobile-Server/app/static/reports -v $(pwd)/tmp:/adk/AdkintunMobile-Server/tmp \
    -v /etc/localtime:/etc/localtime:ro --restart=unless-stopped --log-opt max-size=50m -d server-adk
}

function stop {
    #Stop the aplication
    docker stop $SERVER_NAME
}

function start {
    #start the aplication
    docker start $SERVER_NAME
}

function restart {
    #start the aplication
    docker restart $SERVER_NAME
}


function delete {
    #Stop application
    stop;
    docker rm -f $SERVER_NAME
}

function upgrade {
    delete
    build
    run
}

function login (){
  user="$1"
  password="$2"
  docker run --rm -it --link $DATABASE_NAME:pg -v /etc/localtime:/etc/localtime:ro \
  postgres psql --dbname postgresql://$user:$password@pg/adkintunMobile
}

function backup () {
  user="$1"
  password="$2"
  outfile="$3"
  data_only=$4
  backup_data=""
  message="Backing up database"
  if ! [ -z $data_only ]
  then
    backup_data="-a"
    message="Backing up database, data only"
  fi
  echo $message
  docker run --rm --link $DATABASE_NAME:pg \
  -v /etc/localtime:/etc/localtime:ro postgres /bin/bash -c  "pg_dump $backup_data --dbname \
  postgresql://$user:$password@pg/adkintunMobile | gzip -c" > $(pwd)/backups/$outfile
}


### ------------------ Commands and parameter handling ------------------###

case "$1" in
    login)
        shift
        while getopts 'u:p:' opt; do
          case $opt in
            u) user=$OPTARG;;
            p) password=$OPTARG;;
            \?) echo "Invalid option: -$OPTARG"; usage_login ;;
            :) echo "Option -$OPTARG needs an argument"; usage_login;;
            *) usage_login;;
          esac
        done
        if (($OPTIND != 5))
         then usage_login; fi
        login $user $password
        ;;
    rundb)
      shift
      while getopts 'u:p:' opt; do
        case $opt in
          u) user=$OPTARG;;
          p) password=$OPTARG;;
          \?) echo "Invalid option: -$OPTARG"; usage_rundb;;
          :) echo "Option -$OPTARG needs an argument"; usage_rundb;;
          *) usage_rundb;;
        esac
      done
      if (($OPTIND != 5))
       then usage_rundb; fi
      rundb $user $password
        ;;
    backup)
      shift
      while getopts 'u:p:f:d' opt; do
        case $opt in
          u) user=$OPTARG;;
          p) password=$OPTARG;;
          f) outfile=$OPTARG;;
          d) DATA_ONLY=true ;;
          \?) echo "Invalid option: -$OPTARG"; usage_backup;;
          :) echo "Option -$OPTARG needs an argument"; usage_backup;;
          *) usage_backup;;
        esac
      done
      if (($OPTIND < 7))
       then usage_backup; fi
      backup $user $password $outfile $DATA_ONLY
        ;;
    restore)
      shift
      while getopts 'u:p:f:d' opt; do
        case $opt in
          u) user=$OPTARG;;
          p) password=$OPTARG;;
          f) outfile=$OPTARG;;
          d) delete=true ;;
          \?) echo "Invalid option: -$OPTARG"; usage_restore;;
          :) echo "Option -$OPTARG needs an argument"; usage_restore;;
          *) usage_restore;;
        esac
      done
      if (($OPTIND < 7))
       then usage_restore; fi
      restore $user $password $outfile $delete
      ;;
    runserver) runserver ;;
    populate) populate ;;
    delete) delete ;;
    build) build ;;
    start) start ;;
    restart) restart ;;
    stop) stop ;;
    upgrade) upgrade ;;
    help) usage;;
    *) usage ;;
esac
exit 0;

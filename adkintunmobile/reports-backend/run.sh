#! /bin/bash
## ------------------ Usage functions ------------------ ##

function usage {
    echo "Usage: $0 COMMAND
    Program to manage the server-report containers

    Commands:
    backup    Backup database to file
    build     Build docker images
    delete    Delete docker container for the server
    help      Display this message
    login     Log into the database
    populate  Populate database with initial data
    restore   Restore database with data from file
    rundb     Create and start docker container for database
    runserver Run docker container for the server
    start     Start docker container for the server
    stop      Stop docker container for the server
    upgrade   Rebuild and restart docker container for the  server
    ";
    exit 1;
}

SERVER_NAME="adk-report-backend"
DATABASE_NAME="postgres-report"


function usage_backup {
    echo "Usage: $0 backup {-u <string: user name>} {-p <string: password>} {-f <string: filename>} [-d (data-only)]";
    exit 1;
}

function usage_restore {
  echo "Usage: $0 restore {-u <string: user name>} {-p <string: password>} {-f <string: filename>}";
    exit 1;
}

function usage_rundb {
    echo "Usage: $0 rundb {-u <string: user name>} {-p <string: password>}";
    exit 1;
}
function usage_login {
    echo "Usage: $0 login {-u <string: user name>} {-p <string: password>}";
    exit 1;
}
function usage_populate {
  echo "Usage: $0 populate {-u <string: user name>} {-p <string: password>}";
    exit 1;
}
function usage_import {
  echo "Usage: $0 import {-y <int: year>} {-m <int: month>}";
  exit 1;
}

## ------------------ Command functions ------------------ ##


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function build { # build the docker images
    set -e

    cd "$DIR/populate"
    docker build --tag populate-report .
    cd "$DIR/server"
    docker build --tag server-report .
    cd "$DIR"
}

function stop { # Stop containers
    docker stop $SERVER_NAME
}

function start { # Start containers
    docker start $SERVER_NAME
}

function delete () { # Delete containers
    stop
    docker rm $SERVER_NAME
}

function runserver () { # Create and run the containers

  mkdir -p $(pwd)/tmp
  docker run --name $SERVER_NAME --link $DATABASE_NAME:postgres \
  -v $(pwd)/config.py:/adk/adkintunmobile-frontend/config.py \
  -v $(pwd)/tmp:/adk/adkintunmobile-frontend/tmp -u $(id -u):$(id -u) \
  -v /etc/localtime:/etc/localtime:ro --restart=unless-stopped \
  --log-opt max-size=50m -d server-report

}

function import () {
  month="$1"
  year="$2"
  docker run --rm --name import-report --link $DATABASE_NAME:postgres \
  -v $(pwd)/tmp:/adk/adkintunmobile-frontend/tmp -v /etc/localtime:/etc/localtime:ro \
  -v $(pwd)/config.py:/adk/adkintunmobile-frontend/config.py \
  import-report -y $year -m $month
}

function upgrade {
  # delete container server
  delete
  # rebuild container server
  build
  # run container
  runserver
}

function rundb () {
  user="$1"
  password="$2"

  docker create -v /data-reports --name data-reports postgres /bin/true

  docker run --name $DATABASE_NAME -e POSTGRES_PASSWORD=$password -e POSTGRES_USER=$user \
  -e POSTGRES_DB=visualization --volumes-from data-reports \
  -v /etc/localtime:/etc/localtime:ro --log-opt max-size=50m -d postgres
  #  until curl http://$(docker inspect --format='{{.NetworkSettings.IPAddress}}' $DATABASE_NAME):5432/ | grep '52'
  #  do
        echo "waiting for postgres container..."
        sleep 30
  #  done

}

function populate () { # Populate the database with initial data
  # Run populate docker
  docker run --rm --link $DATABASE_NAME:postgres \
  -v $(pwd)/config.py:/adk/adkintunmobile-frontend/config.py populate-report
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
  postgresql://$user:$password@pg/visualization | gzip -c" > $(pwd)/backups/$outfile
}

function restore () {
  user="$1"
  password="$2"
  infile="$3"
  delete=$4
  # If delete is specified clean the database before restoring
  if ! [ -z $delete ]
  then
    echo "deleting previous data"
    docker run --rm --link $DATABASE_NAME:pg -v /etc/localtime:/etc/localtime:ro \
    postgres /bin/bash -c "echo \"
        DROP SCHEMA public CASCADE;
        CREATE SCHEMA public;
        GRANT ALL ON SCHEMA public TO postgres;
        GRANT ALL ON SCHEMA public TO public;
        COMMENT ON SCHEMA public IS 'standard public schema';\" | psql --dbname \
        postgresql://$user:$password@pg/visualization"

  fi
  docker run --rm --link $DATABASE_NAME:pg -v /etc/localtime:/etc/localtime:ro \
  -v $(pwd)/$infile:/backups/$infile postgres /bin/bash -c \
  "gunzip -c /backups/$infile | psql --dbname postgresql://$user:$password@pg/visualization"
}

function login (){
  user="$1"
  password="$2"
  docker run --rm -it --link $DATABASE_NAME:pg -v /etc/localtime:/etc/localtime:ro \
  postgres psql --dbname postgresql://$user:$password@pg/visualization
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

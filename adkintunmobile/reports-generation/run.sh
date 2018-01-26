#! /bin/bash

function usage {
    echo "Usage: $0 COMMAND
    Program to manage the server-report containers

    Commands:
    build     Build docker images
    delete    Delete docker container for the report generator
    help      Display this message
    run       Create and run docker container for the report generator
    start     Start docker container for the report generator
    stop      Stop docker container for the report generator
    upgrade   Rebuild and restart docker container for the report generator
    report    Generate and import reports for the specified month and year
    ";
    exit 1;
}

function usage_report {
    echo "Usage: $0 report [-y <int : year> ] [-m <int : month>]";
    exit 1;
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function build {
    # build the docker images
    set -e

    docker build --tag report-adk-gen .
}


function run {
    # run the docker containers

    mkdir -p $(pwd)/tmp
    mkdir -p $(pwd)/reports
    docker run --name report-adk-gen -u $(id -u):$(id -g) -m 2g \
    --link adk-report-main:postgres-adk --link postgres-report:postgres-report \
    -v $(pwd)/config.py:/adk/adkintun-reports/config.py -v $(pwd)/reports:/adk/adkintun-reports/app/static/reports \
    -v $(pwd)/tmp:/adk/adkintun-reports/tmp -v /etc/localtime:/etc/localtime:ro --restart=unless-stopped \
    --log-opt max-size=50m -d report-adk-gen

}

function stop {
    #Stop the aplication
    docker stop report-adk-gen
}


function start {
    #start the aplication
    docker start report-adk-gen
}

function restart {
    #start the aplication
    docker restart report-adk-gen
}


function delete {
    #Stop application and delete all data
    stop;
    docker rm -f report-adk-gen
}


function upgrade {
    # delete container server
    delete;
    build;
    run;
}

function report () {
    year=$1
    month=$2
    echo "generating report for year: $year, month: $month"

    mkdir -p $(pwd)/tmp
    mkdir -p $(pwd)/reports
    docker run --rm --name report-adk-gen-${month}-${year} -m 2g -u $(id -u):$(id -u) \
      --link adk-report-main:postgres-adk --link postgres-report:postgres-report \
      -v $(pwd)/config.py:/adk/adkintun-reports/config.py -v $(pwd)/reports:/adk/adkintun-reports/app/static/reports \
      -v $(pwd)/tmp:/adk/adkintun-reports/tmp -v /etc/localtime:/etc/localtime:ro \
      --log-opt max-size=50m report-adk-gen python /adk/adkintun-reports/manage.py generate_and_import_reports -y $year -m $month
}

case "$1" in
    report)
      shift
      while getopts 'y:m:' opt; do
        case $opt in
          y) year=$OPTARG;;
          m) month=$OPTARG;;
          \?) echo "Invalid option: -$OPTARG"; usage_report ;;
          :) echo "Option -$OPTARG needs an argument"; usage_report;;
          *) usage_report;;
        esac
      done
      if (($OPTIND != 5))
       then usage_report; fi
      report $year $month
      ;;
    run) run ;;
    help) usage ;;
    build) build ;;
    start) start ;;
    restart) restart ;;
    stop) stop ;;
    delete) delete ;;
    upgrade) upgrade ;;
    *) usage ;;
esac

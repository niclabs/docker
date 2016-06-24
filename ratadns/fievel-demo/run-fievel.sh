#!/bin/bash

function run_fievel_loop {
    # $1 pcap
    # $2 name
    while true
    do
	fievel -c /etc/fievel.json --input-source $1 --server-id $2
    done;
}

# $1 pcaps directory

for pcap in /var/fievel/pcaps/*.pcap;
do
    server_name=$(basename $pcap | cut -f 1 -d '.')
    echo "Running $server_name"
    run_fievel_loop $pcap $server_name &
    fievel_pids="$! $fievel_pids"
done
echo "Fievel loops pids: $fievel_pids"
last_pid=$fievel_pids

trap "echo Signal captured" SIGINT SIGTERM
wait $last_pid

jobs -p | xargs kill
#force kill fievel as it runs in background of background or something like this
pkill fievel

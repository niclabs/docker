#!/bin/bash
set -e

# Exec the specified command or fall back on bash
if [ $# -eq 0 ]; then
    cmd=( "bash" )
else
    cmd=( "$@" )
fi

# Handle special flags if we're root
if [ $(id -u) == 0 ] ; then
    if runuser -u user -- test ! -w /home/user/work; then
        # Fix permissions on workdir if mounted as volume
        chgrp 100 /home/user/work
        chmod g+rwX /home/user/work
        chmod +6000 /home/user/work
    fi


    if [[ ! -w /home/user/work ]]; then
        # Fix permissions on workdir if mounted as volume
        sudo chgrp 100 /home/user/work
        sudo chmod g+rwX /home/user/work
        sudo chmod +6000 /home/user/work
    fi

    # Warn if the user isn't going to be able to write files to $HOME.
    if [[ ! -w /home/user ]]; then
        echo 'Warning: Container must be run with group "users" to update files in /home/user'
    fi

    # Enable IPV6
    sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0 > /dev/null

    # Execute the command
    exec "${cmd[@]}"
fi

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
    if runuser -u dev -- test ! -w /home/dev/work; then 
        # Fix permissions on workdir if mounted as volume
        chgrp 100 /home/dev/work
        chmod g+rwX /home/dev/work
        chmod +6000 /home/dev/work
    fi

    # Exec the command as dev with the PATH and the rest of
    # the environment preserved
    exec runuser -p -u dev "${cmd[@]}"
else
    # Check if user has overridden the uid/gid that
    # container runs as. Check that the user has an entry in the passwd
    # file and if not add an entry.
    STATUS=0 && whoami &> /dev/null || STATUS=$? && true
    if [[ "$STATUS" != "0" ]]; then
        if [[ -w /etc/passwd ]]; then
            echo "Adding passwd file entry for $(id -u)"
            sed -e "s/^dev:/notdev:/" /etc/passwd > /tmp/passwd
            echo "dev:x:$(id -u):$(id -g):,,,:/home/dev:/bin/bash" >> /tmp/passwd
            cat /tmp/passwd > /etc/passwd
            rm /tmp/passwd
        else
            echo 'Warning: Container must be run with group "root" to update passwd file'
        fi
    fi
    
    if [[ ! -w /home/dev/work ]]; then 
        # Fix permissions on workdir if mounted as volume
        sudo chgrp 100 /home/dev/work
        sudo chmod g+rwX /home/dev/work
        sudo chmod +6000 /home/dev/work
    fi

    # Warn if the user isn't going to be able to write files to $HOME.
    if [[ ! -w /home/dev ]]; then
        echo 'Warning: Container must be run with group "users" to update files in /home/dev'
    fi

    # Execute the command
    exec "${cmd[@]}"
fi

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

    # Exec the command as user with the PATH and the rest of
    # the environment preserved
    exec runuser -p -u user "${cmd[@]}"
else
    # Check if user has overridden the uid/gid that
    # container runs as. Check that the user has an entry in the passwd
    # file and if not add an entry.
    STATUS=0 && whoami &> /dev/null || STATUS=$? && true
    if [[ "$STATUS" != "0" ]]; then
        if [[ -w /etc/passwd ]]; then
            echo "Adding passwd file entry for $(id -u)"
            sed -e "s/^user:/notuser:/" /etc/passwd > /tmp/passwd
            echo "user:x:$(id -u):$(id -g):,,,:/home/user:/bin/bash" >> /tmp/passwd
            cat /tmp/passwd > /etc/passwd
            rm /tmp/passwd
        else
            echo 'Warning: Container must be run with group "root" to update passwd file'
        fi
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

    # Execute the command
    exec "${cmd[@]}"
fi

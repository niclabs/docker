# Dockerized development environment for embedded applications

This container provides a ready to use development environment for building and testing embedded applications. The container can also be used to run Continuous Integration tests in Travis, making it easy to reproduce the testing environment locally. The container is based on the [Contiki NG docker container](https://github.com/contiki-ng/contiki-ng/wiki/Docker), as are these instructions.

The image includes the following tools

* Gcc and libc
* make
* Java JDK
* Python
* Git
* Curl
* IoT-Lab [cli-tools](https://github.com/iot-lab/cli-tools)
* IoT-Lab [ssh-cli-tools](https://github.com/iot-lab/ssh-cli-tools)
* ARM toolchain
* msp430 toolchain
* [Contiki OS sources](http://www.contiki-os.org) with support for IoT-Lab boards (in $HOME/contiki)
* Cooja simulator

We provide a Docker image for this container hosted on DockerHub, as `niclabs/embeddable`.

# Setup

To get started, [install Docker](https://docs.docker.com/install/). Follow these instructions to [install Docker in Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce), for instance:

Make sure your user is added to the unix group `docker`:
```bash
sudo usermod -aG docker <your-user>
```

Log out, and log in again.

Download the embeddable image:
```bash
$ docker pull niclabs/embeddable
```

This will automatically download `niclabs/embeddable:latest`, which is the recommended image for use in Travis and for development.
The image is meant for use with your codebase as a bind mount, which means you make the application repository on the host accessible from inside the container.
This way, you can work on the codebase using host tools / editors, and build/run commands on the same codebase from the container.

Then, it is a good idea to create an alias that will help start docker with all required options.
On Linux, you can add the following to `~/.profile` or similar, for instance, to `~/.bashrc`:
```bash
alias embeddable="docker run --privileged --mount type=bind,source=\$PWD,destination=/home/user/work -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/bus/usb:/dev/bus/usb -ti niclabs/embeddable"
```

For the change to take effect you need to reload the configuration (or open another shell session)
```bash
$ source ~/.bashrc
```

This will mount the current working directory with the equivalent name inside the home directory in the container

# Launching and Exiting

## Shell for new container
To start a bash inside a new container, simply type:
```bash
$ embeddable
```

You will be under `/home/user/work` in the container, which is mapped to the current working directory in the host.

## Additional shell for existing container
Typing `embeddable` as above will launch a new container. Sometimes it is useful to have multiple terminal sessions within a single container, e.g., to run a tunslip6 on one terminal and other commands on another one. To achieve this, start by running:

```bash
$ docker ps
```
This will present you with a list of container IDs. Select the ID of the container you wish to open a terminal for and then

```bash
$ docker exec -it <the ID> /bin/bash
```

## Permissions

By default, the container runs as user 'user' (uid 1000). All of the files under /home/user are group writable by the group 'users' (gid 100). 

Under Linux, mounted folders and files inside the container retain the ownership and permissions of the host, making it impossible to modify by a user with a different user id (and causing commands such as make to fail if the uid of of the host user is different than 1000). For this, the container will change group ownership and permissions of the folder mounted under '/home/user/work' if it is not user writable on launch (see entrypoint.sh). To prevent this while still making the files writable, try one of the following options:

- Mount volume to a folder other than /home/user/work
- Run the container with the UID of the host user, by using docker option `-u $(id -u)`. To maintain write access to files under the /home/user folder, you can also add the option `--group-add users`.

## Exit
To exit a container, use `exit`.

# Usage

From the container, you can directly run build tools (e.g. make) on your project directory and execute unit and integration tests.

You can even start Cooja from the container:
```bash
$ cd ~/contiki/tools/cooja
$ ant
```

Or use the shortcut located in the home directory:
```bash
$ ~/cooja
```

Or directly from the host (outside the container)
```bash
$ embeddable cooja
```

It is also possible to start a container to just run one command, e.g.:
```bash
$ embeddable ls
```

To run CI tests:
```bash
$ embeddable "make test"
```
The user has `sudo` rights with no password (obviously sandboxed in the container).


# On Windows
## Prerequisites
* [VcXsrv][download-vcxsrv]
* [Docker for Windows][install-windows-docker-ce]; enable "Shared Drives" feature with a drive where you have local repository with your project code.

## Limitations
* Cannot use USB from a container as of writing (See: https://github.com/docker/for-win/issues/1018)
* project repository MUST NOT be cloned from a WSL environment (use [Git for Windows](https://gitforwindows.org/) or equivalent instead)

## How to Run
1. Start VcXsrv (run `XLaunch.exe`)
1. Open `cmd.exe` (you can use PowerShell if you want)
1. Hit the following command (replace `/c/Users/foobar/my-project` with a location of of your project local repository in your environment)
```
C:\> docker run --privileged --mount type=bind,source=/c/Users/foobar/my-project,destination=/home/user/work -e DISPLAY="host.docker.internal:0.0" -ti niclabs/embeddable
```
Tested with Windows 10, version 1809.

[install-windows-docker-ce]:https://docs.docker.com/docker-for-windows/install/
[download-vcxsrv]:https://sourceforge.net/projects/vcxsrv/

# On macOS

There are two Docker solutions available: [Docker for Mac](https://docs.docker.com/docker-for-mac/) and [Docker Toolbox on macOS](https://docs.docker.com/toolbox/toolbox_install_mac/).
Refer to [Docker for Mac vs. Docker Toolbox](https://docs.docker.com/docker-for-mac/docker-toolbox/) for general differences between the solutions.

If you want to access USB devices from a Docker container, "Docker Toolbox on macOS" is the **only** choice as of writhing this.
"Docker for Mac" doesn't support USB pass-through (https://docs.docker.com/docker-for-mac/faqs/#questions-about-dockerapp).

## Without XQuartz
If you don't need to run `cooja` with its GUI, the setup procedure becomes simple:

1. install "Docker for Mac" or "Docker Toolbox on macOS"
1. prepare `embeddable` alias
1. run contiker: `$ embeddable bash`

`embeddable` alias you need is slightly different depending on your Docker solution.

### for "Docker for Mac"
```bash
alias embeddable="docker run --privileged \
               --mount type=bind,source=\$PWD,destination=/home/user/work \
               -ti niclabs/embeddable"
```

### for "Docker Toolbox on macOS"
```bash
alias embeddable="docker run --privileged \
               --mount type=bind,source=$PWD,destination=/home/user/work \
               --device=/dev/ttyUSB0 \
               --device=/dev/ttyUSB1 \
               -ti niclabs/embeddable"
```

## With XQuartz

In order to access the X server from a Docker container, you need to use TCP because neither of the Docker solutions can handle Unix domain sockets properly.
The option "Allow connections from network clients" in "Security" tab of "X11 Preferences" is for this purpose.
You can open "X11 Preferences" by clicking "Preferences..." in XQuartz menu.
If you want to limit listening IP address, `socat` is an option.
Note that your host-based firewall may block connections on TCP Port 6000.

1. install "Docker for Mac" or "Docker Toolbox on macOS"
1. install XQuartz: `$ brew cask install xquartz`
1. (option) install socat: `$ brew install socat`
1. open XQuartz: `$ open -a XQuartz`
1. (option) map TCP Port 6000 of 127.0.0.1 to `/tmp/.X11-unix/X0`:
    ```bash
    $ socat TCP-LISTEN:6000,reuseaddr,fork,range=127.0.0.1/32 UNIX-CLIENT:/tmp/.X11-unix/X0
    ```
1. prepare `embeddable` function
1. run contiker: `$ embeddable bash`

`embeddable` alias is a bit complex compared to one for a Linux system.
Actually, we make `embeddable` function instead of alias    .
Put the following lines into `~/.profile` or similar at the end of the file.

### for "Docker for Mac"
```bash
embeddable () {
    COMMAND_STRING="
        cp \${HOME}/dot.Xauthority \${HOME}/.Xauthority
        DISPLAY_NAME=host.docker.internal:0
        export DISPLAY=\${DISPLAY_NAME}.0
        XAUTH_HEXKEY=`xauth list | head -n 1 | awk '{print $3}'`
        xauth add \${DISPLAY_NAME} . \${XAUTH_HEXKEY}
        $@"
    docker run --privileged                                                                 \
               --mount type=bind,source=$(pwd),destination=/home/user/work \
               -v ~/.Xauthority:/home/user/dot.Xauthority:ro                             \
               -ti niclabs/embeddable                                                       \
               "${COMMAND_STRING}"
}
```

### for "Docker Toolbox on macOS"
```bash
embeddable () {
    COMMAND_STRING="
        cp \${HOME}/dot.Xauthority \${HOME}/.Xauthority
        DISPLAY_NAME=`ifconfig vboxnet0 | awk '$1=="inet"{print $2}'`:0
        export DISPLAY=\${DISPLAY_NAME}.0
        XAUTH_HEXKEY=`xauth list | head -n 1 | awk '{print $3}'`
        xauth add \${DISPLAY_NAME} . \${XAUTH_HEXKEY}
        $@"
    docker run --privileged                                                                 \
               --mount type=bind,source=$(pwd),destination=/home/user/work \
               -v ~/.Xauthority:/home/user/dot.Xauthority:ro                             \
               --device=/dev/ttyUSB0                                                        \
               --device=/dev/ttyUSB1                                                        \
               -ti niclabs/embeddable                                                       \
               "${COMMAND_STRING}"
}
```
You need to enable USB devices in VirtualBox; start Virtualbox, and edit the settings for the machine running Docker to allow USB devices. You may want to download Oracle VM VirtualBox Extension Pack for USB 2.0 and USB 3.0 drivers.

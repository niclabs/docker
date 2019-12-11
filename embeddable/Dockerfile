#######################################################
# base image with user management
# for embedded programming
#######################################################
FROM i386/ubuntu:18.04 as base
LABEL maintainer="Felipe Lalanne <flalanne@niclabs.cl>"

ENV DEBIAN_FRONTEND noninteractive
ARG USER=user
ARG UID=1000
ARG GID=100
ARG TINI=v0.18.0


# Base Tools
RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
        sudo \
        && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/*


# Add a script that we will use to correct permissions after running certain commands
ADD fix-permissions /usr/local/bin/

# Set environment variables
ENV USER                ${USER}
ENV HOME                /home/${USER}
ENV WORK                ${HOME}/work
ENV                     TERM="xterm-color"

# Add local files as late as possible to avoid cache busting
ADD https://github.com/krallin/tini/releases/download/${TINI}/tini-i386 /sbin/tini

# Create user, enable X forwarding, add to group dialout
# -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix
RUN useradd -m -s /bin/bash -N -u $UID $USER && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chmod 0440 /etc/sudoers && \
    chmod g+w /etc/passwd && \
    usermod -aG dialout,staff $USER && \
    chmod +x /sbin/tini && \
    mkdir $WORK && \
    # Configure prompt
    echo 'PS1="\u@\h:\W$ "' >> ${HOME}/.bashrc && \
    fix-permissions $HOME

USER root

ENTRYPOINT ["/sbin/tini", "--", "entrypoint.sh"]
CMD ["bash"]

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/

# Set workdir and switch back to dev to avoid accidental container runs as root
WORKDIR $WORK
USER ${UID}

#######################################################
# 64bit base image with user management
# for embedded programming
#######################################################
FROM ubuntu:18.04 as base64

ENV DEBIAN_FRONTEND noninteractive
ARG USER=user
ARG UID=1000
ARG GID=100
ARG TINI=v0.18.0


# Base Tools
RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
        sudo \
        && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/*


# Add a script that we will use to correct permissions after running certain commands
ADD fix-permissions /usr/local/bin/

# Set environment variables
ENV USER                ${USER}
ENV HOME                /home/${USER}
ENV WORK                ${HOME}/work
ENV                     TERM="xterm-color"

# Add local files as late as possible to avoid cache busting
ADD https://github.com/krallin/tini/releases/download/${TINI}/tini /sbin/tini

# Create user, enable X forwarding, add to group dialout
# -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix
RUN useradd -m -s /bin/bash -N -u $UID $USER && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chmod 0440 /etc/sudoers && \
    chmod g+w /etc/passwd && \
    usermod -aG dialout,staff $USER && \
    chmod +x /sbin/tini && \
    mkdir $WORK && \
    # Configure prompt
    echo 'PS1="\u@\h:\W$ "' >> ${HOME}/.bashrc && \
    fix-permissions $HOME

USER root

ENTRYPOINT ["/sbin/tini", "--", "entrypoint.sh"]
CMD ["bash"]

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/

# Set workdir and switch back to dev to avoid accidental container runs as root
WORKDIR $WORK
USER ${UID}

#######################################################
# Minimal build target
# contains minimal set of tools to build c programs and
# test network communications
#######################################################
FROM base as minimal
USER root

# Base Tools
RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
        gcc \
        libc6-dev \
        gdb \
        make \
        sudo \
        git \
        curl wget \
        uncrustify \
        netcat-openbsd \
        net-tools iproute2 iputils-ping iputils-tracepath \
        && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/*

COPY h2spec /usr/local/bin/
COPY coap-client /usr/local/bin/

USER ${USER}


#######################################################
# Contiki-NG build target
# includes contiki sources and necessary dependencies
# and toolchains to build for simulation and ARM
#######################################################

FROM minimal as contiki-ng
USER root

# Base Tools
RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
        openjdk-8-jdk \
        ant \
        python-pip \
        python-serial \
        bzip2 \
        srecord \
        && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt

# Upgrade pip to latest version
# Install IoT-Lab cli-tools and ssh-cli-tools
RUN pip -q install --upgrade pip
RUN pip -q install setuptools && \
    pip install iotlabcli==2.5.4 && iotlabsshcli==0.2.3

# Install ARM toolchain
RUN wget -nv https://launchpad.net/gcc-arm-embedded/5.0/5-2015-q4-major/+download/gcc-arm-none-eabi-5_2-2015q4-20151219-linux.tar.bz2 && \
    tar xjf gcc-arm-none-eabi-5_2-2015q4-20151219-linux.tar.bz2 -C /tmp/ && \
    cp -f -r /tmp/gcc-arm-none-eabi-5_2-2015q4/* /opt/ && \
    rm -rf /tmp/gcc-arm-none-eabi-* gcc-arm-none-eabi-*-linux.tar.bz2 && \
# Install msp430 toolchain
    wget -nv http://simonduq.github.io/resources/mspgcc-4.7.2-compiled.tar.bz2 && \
    tar xjf mspgcc*.tar.bz2 -C /tmp/ && \
    cp -f -r /tmp/msp430/* /opt/ && \
    rm -rf /tmp/msp430 mspgcc*.tar.bz2

# Update path with toolchains
ENV PATH=${PATH}:/opt/bin

# Make sure we're using Java 8 for Cooja
RUN update-java-alternatives --set /usr/lib/jvm/java-1.8.0-openjdk-i386

# Use the local user for what comes next
USER ${USER}
WORKDIR ${HOME}

# Environment variables
ENV CONTIKI_NG          ${HOME}/contiki-ng
ENV CONTIKI             ${CONTIKI_NG}
ENV JAVA_HOME           /usr/lib/jvm/java-8-openjdk-i386
ENV COOJA               ${CONTIKI_NG}/tools/cooja
ENV WORK                ${HOME}/work
ENV                     PATH="${HOME}:${PATH}"

# Set configurable contiki release as argument
ARG CONTIKI_BRANCH=release/v4.4

# Dowload contiki-ng and IoT-Lab boards support
RUN git clone -b ${CONTIKI_BRANCH} https://github.com/contiki-ng/contiki-ng.git /tmp/contiki-ng && \
    git clone https://github.com/iot-lab/iot-lab-contiki-ng.git /tmp/openlab && \
    git clone --depth=1 file:///tmp/contiki-ng ${CONTIKI_NG} && \
    cd ${CONTIKI} && \
        git submodule update --init --recursive && \
        git gc --aggressive --prune=all && \
        git remote set-url origin https://github.com/contiki-ng/contiki-ng.git && \
    cp -r /tmp/openlab/arch/platform/iotlab ${CONTIKI_NG}/arch/platform/ && \
    rm -rf /tmp/openlab && \
    rm -rf /tmp/contiki-ng && \
    fix-permissions ${CONTIKI_NG}

# Create Cooja shortcut and build
RUN echo "#!/bin/bash\nant -Dbasedir=${COOJA} -f ${COOJA}/build.xml run" > ${HOME}/cooja && \
    chmod +x ${HOME}/cooja && \
    # Build cooja and fix all permissions
    ANT_OPTS=-Dfile.encoding=utf8 ant -q -f ${COOJA}/build.xml jar && \
    fix-permissions ${COOJA}

# Set workdir and switch back to dev to avoid accidental container runs as root
WORKDIR $WORK
USER ${UID}

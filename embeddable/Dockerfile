# Container with development environment
# for embedded programming
FROM i386/ubuntu:16.04 as tools
LABEL maintainer="Felipe Lalanne <flalanne@niclabs.cl>"

# Base Tools
RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
        wget \
        git \
        ca-certificates \
        bzip2 \
        && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt

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

ENV OPENLAB /opt/openlab
ENV CONTIKI /opt/contiki

# Dowload IoT-Lab boards support for contiki
RUN git clone https://github.com/iot-lab/openlab.git ${OPENLAB} && \
    git clone https://github.com/iot-lab/contiki.git ${CONTIKI} && \
    cd ${CONTIKI} && \
        git config user.email "devel@niclabs.cl" && \
        git config user.name "NIC Labs Devel" && \
        git remote add contiki https://github.com/contiki-os/contiki.git && \
        git fetch contiki master && \
        git merge --no-edit contiki/master

FROM i386/ubuntu:16.04
COPY --from=tools /opt /opt

ENV DEBIAN_FRONTEND noninteractive
ARG USER=user
ARG UID=1000
ARG GID=100

# Update path with toolchains
ENV PATH=${PATH}:/opt/bin

# Base Tools
RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
        gcc \
        libc6-dev \
        gdb \
        make \
        sudo \
        default-jdk \
        ant \
        git \
        curl \
        python-pip \
        python-serial \
        uncrustify \
        && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip to latest version
# Install IoT-Lab cli-tools and ssh-cli-tools
RUN pip -q install --upgrade pip
RUN pip -q install setuptools && \
    pip install iotlabcli==2.5.4 && iotlabsshcli==0.2.3

# Add a script that we will use to correct permissions after running certain commands
ADD fix-permissions /usr/local/bin/

# Set environment variables
ENV JAVA_HOME           /usr/lib/jvm/default-java
ENV HOME                /home/${USER}
ENV WORK                ${HOME}/work
ENV OPENLAB             ${HOME}/openlab
ENV CONTIKI             ${HOME}/contiki
ENV COOJA               ${CONTIKI}/tools/cooja
ENV                     PATH="${HOME}:${PATH}"

# Create user, enable X forwarding, add to group dialout
# -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix
RUN useradd -m -s /bin/bash -N -u $UID $USER && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chmod 0440 /etc/sudoers && \
    chmod g+w /etc/passwd && \
    usermod -aG dialout $USER && \
    # Move contiki and openlab directories to /home/user
    git clone --depth=1 file:///opt/openlab ${OPENLAB} && \
    cd ${OPENLAB} && \
        git remote set-url origin https://github.com/iot-lab/openlab.git && \
        git gc --aggressive --prune=all && \
    cd ${HOME} && \
    git clone --depth=1 file:///opt/contiki ${CONTIKI} && \
    cd ${CONTIKI} && \
        git remote set-url origin https://github.com/iot-lab/contiki.git && \
        git submodule update --init --recursive && \
        git gc --aggressive --prune=all && \
    rm -rf /opt/openlab && \
    rm -rf /opt/contiki && \
    fix-permissions $HOME

# Set user and workdir for what comes next
USER ${UID}
WORKDIR ${HOME}

# Create Cooja shortcut and work directory
RUN echo "#!/bin/bash\nant -Dbasedir=${COOJA} -f ${COOJA}/build.xml run" > ${HOME}/cooja && \
    chmod +x ${HOME}/cooja && \
    mkdir $WORK

# Build cooja and fix all permissions
RUN ANT_OPTS=-Dfile.encoding=utf8 ant -q -f ${COOJA}/build.xml jar && \
    fix-permissions ${COOJA}

USER root

ENTRYPOINT ["entrypoint.sh"]
CMD ["bash"]

# Add local files as late as possible to avoid cache busting
COPY entrypoint.sh /usr/local/bin/
COPY h2spec /usr/local/bin/

# Set workdir and switch back to dev to avoid accidental container runs as root
WORKDIR $WORK
USER ${UID}

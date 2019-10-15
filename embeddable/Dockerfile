# Container with development environment
# for embedded programming
FROM i386/ubuntu:16.04 as tools
LABEL maintainer="Felipe Lalanne <flalanne@niclabs.cl>"

ARG CONTIKI_BRANCH=release/v4.3

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

# Add fix-permissions to this layer to prevent wasting space
ADD fix-permissions /usr/local/bin/

ENV OPENLAB /tmp/openlab
ENV CONTIKI /opt/contiki-ng
ENV CONTIKI_NG /tmp/contiki-ng

# Dowload IoT-Lab boards support for contiki
RUN git clone -b ${CONTIKI_BRANCH} https://github.com/contiki-ng/contiki-ng.git ${CONTIKI_NG} && \
    git clone https://github.com/iot-lab/iot-lab-contiki-ng.git ${OPENLAB} && \
    git clone --depth=1 file://${CONTIKI_NG} ${CONTIKI} && \
    cd ${CONTIKI} && \
        git submodule update --init --recursive && \
        git gc --aggressive --prune=all && \
        git remote set-url origin https://github.com/contiki-ng/contiki-ng.git && \
    cp -r ${OPENLAB}/arch/platform/iotlab ${CONTIKI}/arch/platform/ && \
    rm -rf ${OPENLAB} && \
    rm -rf ${CONTIKI_NG} && \
    fix-permissions ${CONTIKI}

FROM i386/ubuntu:16.04
COPY --from=tools --chown=0:100 /opt /opt

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
ENV CONTIKI             /opt/contiki-ng
ENV COOJA               ${CONTIKI}/tools/cooja
ENV                     PATH="${HOME}:${PATH}"

# Create user, enable X forwarding, add to group dialout
# -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix
RUN useradd -m -s /bin/bash -N -u $UID $USER && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chmod 0440 /etc/sudoers && \
    chmod g+w /etc/passwd && \
    usermod -aG dialout $USER && \
    fix-permissions $HOME && \
    ln -s ${CONTIKI} ${HOME}/contiki-ng

# Set user and workdir for what comes next
USER ${UID}
WORKDIR ${HOME}

# Create Cooja shortcut and work directory
RUN echo "#!/bin/bash\nant -Dbasedir=${COOJA} -f ${COOJA}/build.xml run" > ${HOME}/cooja && \
    chmod +x ${HOME}/cooja && \
    mkdir $WORK && \
    # Build cooja and fix all permissions
    ANT_OPTS=-Dfile.encoding=utf8 ant -q -f ${COOJA}/build.xml jar && \
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

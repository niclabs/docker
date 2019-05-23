# Container with development environment
# Original: https://github.com/contiki-ng/contiki-ng/blob/develop/tools/docker/Dockerfile
FROM 32bit/ubuntu:16.04

LABEL maintainer="Felipe Lalanne <flalanne@niclabs.cl>"

ENV DEBIAN_FRONTEND noninteractive
ARG username=user

# Tools
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
  echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list && \
  apt-get -qq update && \
  apt-get -qq -y --no-install-recommends install \
    ant \
    build-essential \
    default-jdk \
    doxygen \
    gdb \
    git \
    gksu \
    gtk-sharp2 \
    iputils-tracepath \
    libcanberra-gtk-module:i386 \
    libgtk2.0-0 \
    mono-complete \
    mosquitto \
    mosquitto-clients \
    npm \
    python-pip \
    python-serial \
    rlwrap \
    screen \
    srecord \
    uml-utilities \
    unzip \
    wget \
    > /dev/null \
  && apt-get -qq clean

# Install coap-cli
RUN npm -q install coap-cli -g \
  && sudo ln -s /usr/bin/nodejs /usr/bin/node

# Install ARM toolchain
RUN wget -nv https://launchpad.net/gcc-arm-embedded/5.0/5-2015-q4-major/+download/gcc-arm-none-eabi-5_2-2015q4-20151219-linux.tar.bz2 && \
  tar xjf gcc-arm-none-eabi-5_2-2015q4-20151219-linux.tar.bz2 -C /tmp/ && \
  cp -f -r /tmp/gcc-arm-none-eabi-5_2-2015q4/* /usr/local/ && \
  rm -rf /tmp/gcc-arm-none-eabi-* gcc-arm-none-eabi-*-linux.tar.bz2

# Install msp430 toolchain
RUN wget -nv http://simonduq.github.io/resources/mspgcc-4.7.2-compiled.tar.bz2 && \
  tar xjf mspgcc*.tar.bz2 -C /tmp/ && \
  cp -f -r /tmp/msp430/* /usr/local/ && \
  rm -rf /tmp/msp430 mspgcc*.tar.bz2

# Install NXP toolchain (partial, with binaries excluded. Download from nxp.com)
RUN wget -nv http://simonduq.github.io/resources/ba-elf-gcc-4.7.4-part1.tar.bz2 && \
  wget -nv http://simonduq.github.io/resources/ba-elf-gcc-4.7.4-part2.tar.bz2 && \
  wget -nv http://simonduq.github.io/resources/jn516x-sdk-4163-1416.tar.bz2 && \
  mkdir /tmp/jn516x-sdk /tmp/ba-elf-gcc && \
  tar xjf jn516x-sdk-*.tar.bz2 -C /tmp/jn516x-sdk && \
  tar xjf ba-elf-gcc-*part1.tar.bz2 -C /tmp/ba-elf-gcc && \
  tar xjf ba-elf-gcc-*part2.tar.bz2 -C /tmp/ba-elf-gcc && \
  cp -f -r /tmp/jn516x-sdk /usr/ && \
  cp -f -r /tmp/ba-elf-gcc /usr/ && \
  rm -rf jn516x*.bz2 ba-elf-gcc*.bz2 /tmp/ba-elf-gcc* /tmp/jn516x-sdk*

ENV PATH="/usr/ba-elf-gcc/bin:${PATH}"

## Install nRF52 SDK
RUN wget -nv https://developer.nordicsemi.com/nRF5_IoT_SDK/nRF5_IoT_SDK_v0.9.x/nrf5_iot_sdk_3288530.zip && \
    mkdir /usr/nrf52-sdk && \
    unzip -q nrf5_iot_sdk_3288530.zip -d /usr/nrf52-sdk && \
    rm nrf5_iot_sdk_3288530.zip

ENV NRF52_SDK_ROOT /usr/nrf52-sdk

# Upgrade pip to latest version
RUN pip -q install --upgrade pip
RUN pip -q install setuptools

# Install IoT-Lab cli-tools and ssh-cli-tools
RUN pip install iotlabcli==2.5.4 && iotlabsshcli==0.2.3

# Create user, enable X forwarding, add to group dialout
# -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/${username} && \
    echo "${username}:x:${uid}:${gid}:${username},,,:/home/${username}:/bin/bash" >> /etc/passwd && \
    echo "${username}:x:${uid}:" >> /etc/group && \
    echo "${username} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chmod 0440 /etc/sudoers && \
    chown ${uid}:${gid} -R /home/${username} && \
    usermod -aG dialout ${username}

# Set user for what comes next
USER ${username}

# Environment variables
ENV JAVA_HOME           /usr/lib/jvm/default-java
ENV HOME                /home/${username}
ENV CONTIKI             ${HOME}/contiki
ENV COOJA               ${CONTIKI}/tools/cooja
ENV                     PATH="${HOME}:${PATH}"
WORKDIR                 ${HOME}

# Create Cooja shortcut
RUN echo "#!/bin/bash\nant -Dbasedir=${COOJA} -f ${COOJA}/build.xml run" > ${HOME}/cooja && \
  chmod +x ${HOME}/cooja

# Download, build and install Renode
RUN git clone --quiet https://github.com/renode/renode.git \
  && cd ${HOME}/renode \
  && git checkout v1.3 \
  && ./build.sh
ENV PATH="${HOME}/renode:${PATH}"

# Dowload IoT-Lab boards support for contiki
RUN git clone https://github.com/iot-lab/openlab.git && \ 
        git clone --recursive https://github.com/iot-lab/contiki.git ${CONTIKI}

# Upgrade contiki source
RUN cd ${CONTIKI} && \
        git config --global user.email "info@niclabs.cl" && \
        git config --global user.name "NIC Chile Research Labs" && \
        git remote add contiki https://github.com/contiki-os/contiki.git && \
        git fetch contiki && \
        git merge --no-edit contiki/master

# Build cooja
RUN ANT_OPTS=-Dfile.encoding=utf8 ant -q -f ${COOJA}/build.xml jar

# Working directory
WORKDIR ${HOME}

# Enable IPv6 -- must be done at runtime, hence added to .profile
RUN echo "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0 > /dev/null" >> ${HOME}/.profile

# Start a bash shell
CMD bash --login

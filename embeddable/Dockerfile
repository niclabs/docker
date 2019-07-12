# Container with development environment
# Original: https://github.com/contiki-ng/contiki-ng/blob/develop/tools/docker/Dockerfile
FROM 32bit/ubuntu:16.04

LABEL maintainer="Felipe Lalanne <flalanne@niclabs.cl>"

ENV DEBIAN_FRONTEND noninteractive
ARG USER=user
ARG UID=1000
ARG GID=100

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
    libncurses-dev \
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
    curl \
    > /dev/null \
  && apt-get -qq clean && \
  rm -rf /var/lib/apt/lists/*

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
    fix-permissions $HOME

# Set user and workdir for what comes next
USER ${UID}
WORKDIR ${HOME}

# Create Cooja shortcut and work directory
RUN echo "#!/bin/bash\nant -Dbasedir=${COOJA} -f ${COOJA}/build.xml run" > ${HOME}/cooja && \
  chmod +x ${HOME}/cooja && \
  mkdir $WORK

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
        git config user.email "devel@niclabs.cl" && \
        git config user.name "NIC Labs Devel" && \
        git remote add contiki https://github.com/contiki-os/contiki.git && \
        git fetch contiki && \
        git merge --no-edit contiki/master

# Build cooja and fix all permissions
RUN ANT_OPTS=-Dfile.encoding=utf8 ant -q -f ${COOJA}/build.xml jar && \
        fix-permissions $HOME

USER root

ENTRYPOINT ["entrypoint.sh"]
CMD ["bash"]

# Add local files as late as possible to avoid cache busting
COPY entrypoint.sh /usr/local/bin/

# Set workdir and switch back to dev to avoid accidental container runs as root
WORKDIR $WORK
USER ${UID}

FROM debian:8
MAINTAINER Francisco Cifuentes

# Install distribution package dependencies
RUN apt-get -y update && \
    apt-get install -y \
        check \
        curl \
        g++ \
        gcc \
        git \
        libhiredis0.10 \
        libhiredis-dev \
        libjson-c2 \
        libjson-c-dev \
        libldns1 \
        libldns-dev \
        liblua5.2-0 \
        liblua5.2-dev \
        libpcap0.8 \
        libpcap0.8-dev \
        make

# Install non-available-as-packages dependencies
RUN cd /opt && \
    curl -O https://cmake.org/files/v3.4/cmake-3.4.1-Linux-x86_64.tar.gz && \
    tar -zxf cmake-3.4.1-Linux-x86_64.tar.gz

ENV PATH /opt/cmake-3.4.1-Linux-x86_64/bin:$PATH
    
# Get project sources
RUN cd /opt && \
    git clone https://github.com/niclabs/ratadns-fievel.git && \
    cd ratadns-fievel && \
    git checkout demo1

# Build project
RUN mkdir -p /opt/ratadns-fievel/build && \
    cd /opt/ratadns-fievel/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && \
    make install

# Copy configurations and set defaults
RUN mkdir -p /var/fievel/prers && \
    cp -R /opt/ratadns-fievel/prers/ /var/fievel/prers && \
    cp /opt/ratadns-fievel/fievel.json /etc/fievel.json

# Set the running command
CMD ["/usr/bin/fievel", "-c", "/etc/fievel.json"]

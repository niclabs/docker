FROM debian:latest
MAINTAINER Francisco Cifuentes

# Prepare
RUN apt-get -y update; \
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
        make; \
    cd /opt; \
    curl -O https://cmake.org/files/v3.4/cmake-3.4.1-Linux-x86_64.tar.gz; \
    tar -zxf cmake-3.4.1-Linux-x86_64.tar.gz

ENV PATH /opt/cmake-3.4.1-Linux-x86_64/bin:$PATH
    
# Make
RUN cd /opt; \
    git clone https://github.com/niclabs/ratadns-fievel.git; \
    cd ratadns-fievel; \
    git checkout f3bb62e; \
    mkdir build; \
    cd build; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr ..; \
    make; \
    make install; \
    cd ..; \
    cp -R prers/ /var/fievel/prers; \
    cp fievel.json /etc/fievel.json

CMD ["/usr/bin/fievel", "-c", "/etc/fievel.json"]

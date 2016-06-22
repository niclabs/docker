FROM debian:latest
MAINTAINER Francisco Cifuentes

# Prepare
RUN apt-get -y update; \
    apt-get install -y gcc g++ make git curl liblua5.2-0 libpcap0.8 \
        libhiredis0.10 libldns1 libjson-c2 liblua5.2-dev libpcap0.8-dev check \
        libhiredis-dev libldns-dev libjson-c-dev; \
    cd /opt; \
    curl -O https://cmake.org/files/v3.4/cmake-3.4.1-Linux-x86_64.tar.gz; \
    tar -zxf cmake-3.4.1-Linux-x86_64.tar.gz

ENV PATH /opt/cmake-3.4.1-Linux-x86_64/bin:$PATH
    
# Make
RUN cd /opt; \
    git clone https://github.com/niclabs/ratadns-fievel.git; \
    cd ratadns-fievel; \
    git checkout 8b16bad; \
    mkdir build; \
    cd build; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr ..; \
    make; \
    make install; \
    cd ..; \
    cp -R prers/ /var/fievel/prers

COPY fievel.json /etc/fievel.json

COPY run-fievel.sh /usr/bin/run-fievel.sh

CMD ["/usr/bin/run-fievel.sh"]

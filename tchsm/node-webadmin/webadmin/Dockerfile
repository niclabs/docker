FROM python:3.5.1-slim

MAINTAINER Francisco Montoto <montoto@niclabs.cl>

RUN apt-get update && apt-get install --no-install-recommends -y \
                                                                 cmake \
                                                                 curl \
                                                                 g++ \
                                                                 gcc \
                                                                 git \
                                                                 libbotan1.10-dev \
                                                                 libconfig-dev \
                                                                 libedit-dev \
                                                                 libgmp-dev \
                                                                 libidn11-dev \
                                                                 libjansson-dev \
                                                                 libjson-c-dev \
                                                                 libmhash-dev \
                                                                 libsodium-dev \
                                                                 libsqlite3-dev \
                                                                 libunbound-dev \
                                                                 liburcu-dev \
                                                                 make \
                                                                 supervisor \
                                                                 uuid-dev

# Clone zmq
RUN curl -LO https://github.com/zeromq/zeromq4-1/releases/download/v4.1.4/zeromq-4.1.4.tar.gz \
 && echo 'b632a4b6f8a14390dc17824e37ff7b10831ce2b4  zeromq-4.1.4.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f zeromq-4.1.4.tar.gz && rm zeromq-4.1.4.tar.gz \
 && cd /tmp/zeromq-4.1.4 && ./configure --with-libsodium && make && make install \
 && ldconfig \
 && cd / && rm -r /tmp/zeromq-4.1.4

#Clone tclib
RUN mkdir /home/tclib \
 && git clone --depth=2 https://github.com/niclabs/tchsm-libtc.git \
 && cd tchsm-libtc && mkdir build && cd build \
 && cmake .. && make install \
 && cd / && rm -r /home/tclib

# Clone node project
RUN mkdir /home/node \
 && cd /home/node \
 && git clone https://github.com/niclabs/tchsm-libdtc.git \
 && cd tchsm-libdtc \
 && git checkout v0.1 \
 && mkdir build && cd build && cmake -DBUILD_TESTING=OFF .. && make tchsm_node install \
 && cd / && cp /home/node/tchsm-libdtc/scripts/create_config.py /usr/local/bin \
 && chmod +x /usr/local/bin/create_config.py && rm -r /home/node

RUN pip install uwsgi

# Clone project
RUN mkdir /home/nodeadmin \
 && cd /home/nodeadmin \
 && git clone https://github.com/niclabs/tchsm-nodeadmin \
 && cd tchsm-nodeadmin \
 #TODO checkout to a release or commit.
# && git checkout f9e657b
 && git checkout eb7b2a37b6d0cf423aba3116c0507bd7d8b60368

RUN pip install -r /home/nodeadmin/tchsm-nodeadmin/requirements.txt

COPY supervisor.conf /home/nodeadmin/tchsm-nodeadmin
COPY uwsgi.ini /home/nodeadmin/tchsm-nodeadmin
COPY config.py /home/nodeadmin/tchsm-nodeadmin

WORKDIR /home/nodeadmin/tchsm-nodeadmin

ENV NODE_CONF_PATH /home/nodeadmin/tchsm-nodeadmin/conf/node.conf

RUN apt-get --purge remove -y cmake \
                              curl \
                              g++ \
                              gcc \
                              git \
                              make

CMD ["/home/nodeadmin/tchsm-nodeadmin/conf/start.sh"]

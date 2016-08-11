FROM alpine:edge

# MHASH is only at testing repo
RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Certificates needed to use wget ssl
RUN apk upgrade --update

RUN apk add cmake \
            gcc \
            gmp-dev \
            g++ \
            json-c-dev \
            libconfig-dev \
            libsodium-dev \
            libuuid \
            make \
            mhash-dev@testing \
            # WGET ssl helper
            openssl \
            python \
            sqlite-dev \
            util-linux-dev \
            zeromq-dev

# RUN apt-get update -qq

# RUN apt-get install -y --no-install-recommends \
        # build-essential \
        # git \
        # m4 \
        # python \
        # software-properties-common \
        # unzip \
        # wget

# RUN apt-get install -y \
        # check \
        # cmake \
        # libbotan1.10-dev \
        # libconfig-dev \
        # libgmp-dev \
        # libjson-c-dev \
        # libmhash-dev \
        # libsodium-dev \
        # libsqlite3-dev \
        # uuid-dev

# RUN wget https://github.com/zeromq/zeromq4-1/releases/download/v4.1.4/zeromq-4.1.4.tar.gz
# RUN tar -xzC /tmp -f zeromq-4.1.4.tar.gz && rm zeromq-4.1.4.tar.gz

RUN wget https://botan.randombit.net/releases/Botan-1.11.30.tgz
RUN tar -xzC /tmp -f Botan-1.11.30.tgz && rm Botan-1.11.30.tgz

RUN wget https://github.com/niclabs/tchsm-libtc/archive/master.zip
RUN unzip master.zip -d /tmp && rm master.zip

RUN wget https://github.com/niclabs/tchsm-libdtc/archive/master.zip
RUN unzip master.zip -d /tmp && rm master.zip

#RUN cd /tmp/libsodium-1.0.9/ && ./configure && make && make install

# RUN cd /tmp/zeromq-4.1.4 && ./configure --with-libsodium && make && make install && ldconfig

RUN cd /tmp/tchsm-libtc-master && mkdir build && cd build && cmake .. && make install

RUN cd /tmp/Botan-1.11.30 && ./configure.py  && make && make install

ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig
#RUN echo $PKG_CONFIG_PATH

RUN cd /tmp/tchsm-libdtc-master && mkdir build && cd build && cmake -DBUILD_TESTING=OFF .. && make tchsm_node install

CMD ["/bin/sh"]

FROM ubuntu:latest

RUN apt-get update -qq

RUN apt-get install -y --no-install-recommends libbotan1.10-dev \
                                               libsodium-dev \
                                               libzmq3-dev

RUN apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        git \
        libconfig-dev \
        libgmp-dev \
        libjson-c-dev \
        libmhash-dev \
        libsqlite3-dev \
        unzip \
        uuid-dev \
        wget

RUN wget https://github.com/niclabs/tchsm-libtc/archive/master.zip \
 && unzip master.zip -d /tmp && rm master.zip \
 && cd /tmp/tchsm-libtc-master && mkdir build && cd build && cmake -DBUILD_TESTING=OFF .. && make install \
 && cd / && rm -r /tmp/tchsm-libtc-master

RUN wget http://github.com/niclabs/tchsm-libdtc/archive/v0.1.tar.gz \
 && echo 'fea5b5e61430daec2a33a46b002fd3358bf3e9a2  v0.1.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f v0.1.tar.gz && rm v0.1.tar.gz \
 && cd /tmp/tchsm-libdtc-0.1 \
 && mkdir build && cd build \
 && cmake -DBUILD_TESTING=OFF .. \
 && make install \
 && cd / && rm -r /tmp/tchsm-libdtc-0.1

RUN apt-get purge -y \
        build-essential \
        cmake \
        unzip \
        wget

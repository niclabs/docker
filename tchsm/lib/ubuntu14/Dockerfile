FROM ubuntu:14.04

MAINTAINER Francisco Montoto <montoto@niclabs.cl>

RUN apt-get update -qq

RUN apt-get install -y --no-install-recommends \
        build-essential \
        git \
        m4 \
        python \
        unzip \
        wget

RUN apt-get install -y \
        cmake \
        libconfig-dev \
        libedit-dev \
        libgmp-dev \
        libidn11-dev \
        libjansson-dev \
        libjson-c-dev \
        libmhash-dev \
        libsqlite3-dev \
        libunbound-dev \
        liburcu-dev \
        uuid-dev

RUN mkdir gpg_keys

COPY gpg_keys/ gpg_keys/

RUN gpg --import /gpg_keys/botan.gpg /gpg_keys/libsodium.gpg

RUN wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.9.tar.gz \
 && wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.9.tar.gz.sig \
 && gpg --verify libsodium-1.0.9.tar.gz.sig libsodium-1.0.9.tar.gz \
 && tar -xzC /tmp -f libsodium-1.0.9.tar.gz && rm libsodium-1.0.9.tar.gz \
 && cd /tmp/libsodium-1.0.9/ && ./configure && make && sudo make install \
 && cd / && rm -r /tmp/libsodium-1.0.9

RUN wget https://github.com/zeromq/zeromq4-1/releases/download/v4.1.4/zeromq-4.1.4.tar.gz \
 && echo 'b632a4b6f8a14390dc17824e37ff7b10831ce2b4  zeromq-4.1.4.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f zeromq-4.1.4.tar.gz && rm zeromq-4.1.4.tar.gz \
 && cd /tmp/zeromq-4.1.4 && ./configure --with-libsodium && make && sudo make install && sudo ldconfig \
 && cd / && rm -r /tmp/zeromq-4.1.4

RUN wget http://botan.randombit.net/releases/Botan-1.11.29.tgz \
 && wget  http://botan.randombit.net/releases/Botan-1.11.29.tgz.asc \
 && ls && gpg --verify Botan-1.11.29.tgz.asc Botan-1.11.29.tgz \
 && tar -xzC /tmp -f Botan-1.11.29.tgz && rm Botan-1.11.29.tgz \
 && cd /tmp/Botan-1.11.29 && ./configure.py && make && sudo make install \
 && cd / && rm -r /tmp/Botan-1.11.29

RUN wget https://github.com/niclabs/tchsm-libtc/archive/master.zip \
 && unzip master.zip -d /tmp && rm master.zip \
 && cd /tmp/tchsm-libtc-master && mkdir build && cd build && cmake -DBUILD_TESTING=OFF .. && sudo make install \
 && cd / && rm -r /tmp/tchsm-libtc-master

RUN wget http://github.com/niclabs/tchsm-libdtc/archive/v0.1.tar.gz \
 && echo 'fea5b5e61430daec2a33a46b002fd3358bf3e9a2  v0.1.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f v0.1.tar.gz && rm v0.1.tar.gz \
 && cd /tmp/tchsm-libdtc-0.1 \
 && mkdir build && cd build \
 && cmake -DBUILD_TESTING=OFF .. \
 && make install \
 && cd / && rm -r /tmp/tchsm-libdtc-0.1

RUN sudo apt-get purge -y \
        build-essential \
        cmake \
        gcc \
        git \
        libconfig-dev \
        python \
        unzip \
        wget

RUN sudo apt-get purge -y \
        libconfig-dev \
        libedit-dev \
        libgmp-dev \
        libidn11-dev \
        libjansson-dev \
        libjson-c-dev \
        libmhash-dev \
        libsqlite3-dev \
        libunbound-dev \
        liburcu-dev \
        uuid-dev \

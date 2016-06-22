FROM ubuntu:latest

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
        libsodium-dev \
        libsqlite3-dev \
        libunbound-dev \
        liburcu-dev \
        uuid-dev

RUN wget https://github.com/zeromq/zeromq4-1/releases/download/v4.1.4/zeromq-4.1.4.tar.gz \
 && tar -xzC /tmp -f zeromq-4.1.4.tar.gz && rm zeromq-4.1.4.tar.gz

RUN wget http://botan.randombit.net/releases/Botan-1.11.29.tgz \
 && tar -xzC /tmp -f Botan-1.11.29.tgz && rm Botan-1.11.29.tgz

RUN wget https://github.com/niclabs/tchsm-libtc/archive/master.zip \
 && unzip master.zip -d /tmp && rm master.zip

RUN cd /tmp/zeromq-4.1.4 && ./configure --with-libsodium && make && make install && ldconfig

RUN cd /tmp/Botan-1.11.29 && ./configure.py && make && make install

RUN cd /tmp/tchsm-libtc-master && mkdir build && cd build && cmake -DBUILD_TESTING=OFF .. && make install

RUN cd /tmp && mkdir libdtc && cd libdtc \
 && git clone https://github.com/niclabs/tchsm-libdtc.git \
 && cd tchsm-libdtc \
 && git checkout system_test_fix \
# TODO TEMPORAL
# && git checkout a9a3e299a46 \
 && mkdir build && cd build \
 && cmake -DBUILD_TESTING=OFF .. \
 && make install \
 && cd / && rm -r /tmp/libdtc

# Testing
# RUN wget ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz \
#  && tar -xzC /tmp -f libffi-3.2.1.tar.gz && rm libffi-3.2.1.tar.gz \
#  && cd /tmp/libffi-3.2.1 && ./configure && make && make install \
#  && cd /tmp/libdtc/tchsm-libdtc/build \
#  && make system_test check \
#  && sudo apt-get install -y check python3-pip libssl-dev \
#  && sudo pip3 install -r ../tests/system_test/requirements.txt \
#  && python ../tests/system_test/system_test.py --debug  -v -r 'PKCS11 THREE NODES, O' .

RUN apt-get purge -y \
        build-essential \
        cmake \
        gcc \
        git \
        libconfig-dev \
        unzip \
        wget

CMD ["bash"]

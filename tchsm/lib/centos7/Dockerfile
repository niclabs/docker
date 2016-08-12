FROM centos:7

RUN yum install -y \
        autogen \
        bzip2 \
        gcc \
        gcc-c++ \
        git \
        gmp-devel \
        jansson-devel \
        libedit-devel \
        make \
        m4 \
        unzip

RUN yum install -y \
    cmake \
    json-c-devel \
    libconfig-devel \
    libuuid-devel \
    sqlite-devel


RUN curl -O https://download.libsodium.org/libsodium/releases/libsodium-1.0.9.tar.gz \
 && tar -xzC /tmp -f libsodium-1.0.9.tar.gz && rm libsodium-1.0.9.tar.gz \
 && cd /tmp/libsodium-1.0.9 && ./configure && make && make install \
 && cd / && rm -r /tmp/libsodium-1.0.9

ENV PKG_CONFIG_PATH ${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig

RUN curl -LO https://github.com/zeromq/zeromq4-1/releases/download/v4.1.4/zeromq-4.1.4.tar.gz \
 && tar -xzC /tmp -f zeromq-4.1.4.tar.gz && rm zeromq-4.1.4.tar.gz \
 && cd /tmp/zeromq-4.1.4 && ./configure --with-libsodium && make && make install && ldconfig \
 && cd / && rm -r /tmp/zeromq-4.1.4

RUN curl -LO http://botan.randombit.net/releases/Botan-1.11.29.tgz \
 && tar -xzC /tmp -f Botan-1.11.29.tgz && rm Botan-1.11.29.tgz \
 && cd /tmp/Botan-1.11.29 && ./configure.py && make && make install \
 && cd / && rm -r /tmp/Botan-1.11.29

RUN curl -LO http://ufpr.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz \
 && tar -xzC /tmp -f mhash-0.9.9.9.tar.gz && rm mhash-0.9.9.9.tar.gz \
 && cd /tmp/mhash-0.9.9.9 && ./configure && make && make install \
 && cd / && rm -r /tmp/mhash-0.9.9.9

RUN curl -LO https://github.com/niclabs/tchsm-libtc/archive/master.zip \
 && unzip master.zip -d /tmp && rm master.zip \
 && cd /tmp/tchsm-libtc-master && mkdir build && cd build && cmake -DBUILD_TESTING=OFF .. && make install \
 && cd / && rm -r /tmp/tchsm-libtc-master

RUN cd /tmp && mkdir libdtc && cd libdtc \
 && git clone https://github.com/niclabs/tchsm-libdtc.git \
 && cd tchsm-libdtc \
 && git checkout system_test_fix \
# TODO TEMPORAL
# && git checkout a9a3e299a46 \
 && mkdir build && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=OFF .. \
 && make install

# Testing
# RUN curl -LO ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz \
#  && tar -xzC /tmp -f libffi-3.2.1.tar.gz && rm libffi-3.2.1.tar.gz \
#  && cd /tmp/libffi-3.2.1 && ./configure && make && make install \
#  && cd / && rm -r /tmp/libffi-3.2.1 \
#  && curl -LO https://sourceforge.net/projects/check/files/check/0.10.0/check-0.10.0.tar.gz \
#  && tar -xzC /tmp -f check-0.10.0.tar.gz && rm check-0.10.0.tar.gz \
#  && cd /tmp/check-0.10.0 && ./configure && make && make install \
#  && cd / && rm -r /tmp/check-0.10.0 \
#  && yum install -y python-devel epel-release openssl-devel \
#  && yum install -y check-devel python-pip libssl-devel \
#  && cd /tmp/libdtc/tchsm-libdtc/build && rm -r * && cmake -DBUILD_TESTING=ON .. \
#  && make system_test check \
#  && python -m pip install -r ../tests/system_test/requirements.txt
#RUN python ../tests/system_test/system_test.py --debug  -v -r 'PKCS11 THREE NODES, O' .

FROM centos:7

RUN yum install -y \
            autogen \
            cmake \
            json-c-devel \
            gmp-devel \
            jansson-devel \
            libconfig-devel \
            libedit-devel \
            libuuid-devel \
            make \
            m4 \
            sqlite-devel \
            wget

RUN yum install -y gcc gcc-c++

ENV PKG_CONFIG_PATH ${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig

RUN wget https://download.libsodium.org/libsodium/releases/old/libsodium-1.0.13.tar.gz \
 && tar -xzC /tmp -f libsodium-1.0.13.tar.gz && rm -f libsodium-1.0.13.tar.gz \
 && cd /tmp/libsodium-1.0.13/ && ./configure && make && make install \
 && cd / && rm -rf /tmp/libsodium-1.0.13

RUN wget https://github.com/zeromq/zeromq4-1/releases/download/v4.1.4/zeromq-4.1.4.tar.gz \
 && tar -xzC /tmp -f zeromq-4.1.4.tar.gz && rm -f zeromq-4.1.4.tar.gz \
 && cd /tmp/zeromq-4.1.4 && ./configure --with-libsodium && make && make install \
 && ldconfig \
 && cd / && rm -rf /tmp/zeromq-4.1.4

RUN wget http://botan.randombit.net/releases/old/Botan-1.11.29.tgz \
 && tar -xzC /tmp -f Botan-1.11.29.tgz && rm -f Botan-1.11.29.tgz \
 && cd /tmp/Botan-1.11.29 && ./configure.py --cc-bin=${CC} && make && make install \
 && cd / && rm -rf /tmp/Botan-1.11.29

RUN wget http://ufpr.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz \
 && tar -xzC /tmp -f mhash-0.9.9.9.tar.gz && rm -f mhash-0.9.9.9.tar.gz \
 && cd /tmp/mhash-0.9.9.9 && ./configure && make && make install \
 && cd / && rm -rf /tmp/mhash-0.9.9.9

RUN wget https://github.com/niclabs/tchsm-libtc/archive/v0.2.tar.gz \
 && echo '83b28ef1c123777f17548228a32fd1f2f42ec2f3  v0.2.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f v0.2.tar.gz && rm -f v0.2.tar.gz \
 && cd /tmp/tchsm-libtc-0.2 && mkdir build \
 && cd build && cmake -DBUILD_TESTING=OFF .. && make install \
 && cd / && rm -rf /tmp/tchsm-libtc-0.2

RUN wget http://github.com/niclabs/tchsm-libdtc/archive/v0.1.tar.gz \
 && echo 'fea5b5e61430daec2a33a46b002fd3358bf3e9a2  v0.1.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f v0.1.tar.gz && rm -f v0.1.tar.gz \
 && cd /tmp/tchsm-libdtc-0.1 \
 && mkdir build && cd build \
 && cmake -DBUILD_TESTING=OFF .. \
 && make install \
 && cd / && rm -rf /tmp/tchsm-libdtc-0.1

RUN yum remove -y \
            autogen \
            cmake \
            json-c-devel \
            gmp-devel \
            jansson-devel \
            libconfig-devel \
            libedit-devel \
            libuuid-devel \
            make \
            m4 \
            sqlite-devel \
            wget

RUN yum remove -y gcc gcc-c++
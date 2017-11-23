FROM alpine:edge

MAINTAINER Francisco Montoto <montoto@niclabs.cl>

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
            # WGET ssl helper
            openssl \
            python \
            sqlite-dev \
            util-linux-dev \
            zeromq-dev

RUN wget https://botan.randombit.net/releases/old/Botan-1.11.30.tgz \
 && tar -xzC /tmp -f Botan-1.11.30.tgz && rm Botan-1.11.30.tgz \
 && cd /tmp/Botan-1.11.30 && ./configure.py  && make && make install \
 && cd / && rm -r /tmp/Botan-1.11.30

RUN wget http://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz \
 && tar -xzC /tmp -f mhash-0.9.9.9.tar.gz && rm mhash-0.9.9.9.tar.gz \
 && cd /tmp/mhash-0.9.9.9 && ./configure  && make && make install \
 && cd / && rm -r /tmp/mhash-0.9.9.9

ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig

RUN wget https://github.com/niclabs/tchsm-libtc/archive/master.zip \
 && unzip master.zip -d /tmp && rm master.zip \
 && cd /tmp/tchsm-libtc-master && mkdir build && cd build && cmake .. && make install \
 && cd / && rm -r /tmp/tchsm-libtc-master

RUN wget https://github.com/niclabs/tchsm-libdtc/archive/v0.1.zip \
 && unzip v0.1.zip -d /tmp && rm v0.1.zip \
 && cd /tmp/tchsm-libdtc-0.1 && mkdir build \
 && cd build && cmake -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=OFF .. && make tchsm_node install \
 && cd / && rm -r /tmp/tchsm-libdtc-0.1

RUN apk del cmake \
            gcc \
            g++ \
            make \
            python \
            util-linux-dev \
            openssl

ENTRYPOINT ["/usr/local/bin/tchsm_node"]
CMD ["-c", "/etc/node.conf"]

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

# RUN wget https://github.com/zeromq/zeromq4-1/releases/download/v4.1.4/zeromq-4.1.4.tar.gz
# RUN tar -xzC /tmp -f zeromq-4.1.4.tar.gz && rm zeromq-4.1.4.tar.gz

# RUN cd /tmp/zeromq-4.1.4 && ./configure --with-libsodium && make && make install && ldconfig

RUN wget https://botan.randombit.net/releases/Botan-1.11.30.tgz \
 && tar -xzC /tmp -f Botan-1.11.30.tgz && rm Botan-1.11.30.tgz \
 && cd /tmp/Botan-1.11.30 && ./configure.py  && make && make install \
 && cd / && rm -r /tmp/Botan-1.11.30

ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig

RUN wget https://github.com/niclabs/tchsm-libtc/archive/master.zip \
 && unzip master.zip -d /tmp && rm master.zip \
 && cd /tmp/tchsm-libtc-master && mkdir build && cd build && cmake .. && make install \
 && cd / && rm -r /tmp/tchsm-libtc-master

RUN wget https://github.com/niclabs/tchsm-libdtc/archive/master.zip \
 && unzip master.zip -d /tmp && rm master.zip \
 && cd /tmp/tchsm-libdtc-master && mkdir build \
 && cd build && cmake -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=OFF .. && make tchsm_node install \
 && cd / && rm -r /tmp/tchsm-libdtc-master

RUN apk del cmake \
            gcc \
            g++ \
            make \
            python \
            util-linux-dev \
            openssl

ENTRYPOINT ["/usr/local/bin/tchsm_node"]
CMD ["-c", "/etc/node.conf"]

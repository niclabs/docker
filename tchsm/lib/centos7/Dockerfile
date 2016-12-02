FROM centos:7

RUN yum install -y \
            autogen \
            bzip2 \
            cmake \
            curl \
            json-c-devel \
            git \
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

RUN mkdir gpg_keys

COPY gpg_keys/ gpg_keys/

RUN gpg --import /gpg_keys/botan.gpg /gpg_keys/libsodium.gpg

RUN curl -LO https://download.libsodium.org/libsodium/releases/libsodium-1.0.9.tar.gz \
 && curl -LO https://download.libsodium.org/libsodium/releases/libsodium-1.0.9.tar.gz.sig \
 && gpg --verify libsodium-1.0.9.tar.gz.sig libsodium-1.0.9.tar.gz \
 && tar -xzC /tmp -f libsodium-1.0.9.tar.gz && rm libsodium-1.0.9.tar.gz \
 && cd /tmp/libsodium-1.0.9/ && ./configure && make && make install \
 && cd / && rm -r /tmp/libsodium-1.0.9

RUN curl -LO https://github.com/zeromq/zeromq4-1/releases/download/v4.1.4/zeromq-4.1.4.tar.gz \
 && echo 'b632a4b6f8a14390dc17824e37ff7b10831ce2b4  zeromq-4.1.4.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f zeromq-4.1.4.tar.gz && rm zeromq-4.1.4.tar.gz \
 && cd /tmp/zeromq-4.1.4 && ./configure --with-libsodium && make && make install \
 && ldconfig \
 && cd / && rm -r /tmp/zeromq-4.1.4

RUN curl -LO  http://botan.randombit.net/releases/Botan-1.10.13.tgz \
 && curl -LO  http://botan.randombit.net/releases/Botan-1.10.13.tgz.asc \
 && gpg --verify Botan-1.10.13.tgz.asc Botan-1.10.13.tgz \
 && tar -xzC /tmp -f Botan-1.10.13.tgz && rm Botan-1.10.13.tgz \
 && cd /tmp/Botan-1.10.13 && ./configure.py --cc-bin=${CC} && make && make install \
 && cd / && rm -r /tmp/Botan-1.10.13

RUN curl -LO http://ufpr.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz \
 && echo 'c898de5ea60d9e0873a1b73caa031bb1b5797c03  mhash-0.9.9.9.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f mhash-0.9.9.9.tar.gz && rm mhash-0.9.9.9.tar.gz \
 && cd /tmp/mhash-0.9.9.9 && ./configure && make && make install \
 && cd / && rm -r /tmp/mhash-0.9.9.9

RUN curl -LO http://www.hyperrealm.com/libconfig/libconfig-1.5.tar.gz \
 && echo '24306c7efce07669a4053d0977a45e2f3a3add79  libconfig-1.5.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f libconfig-1.5.tar.gz && rm libconfig-1.5.tar.gz \
 && cd /tmp/libconfig-1.5 && ./configure && make install \
 && cd / && rm -r /tmp/libconfig-1.5

RUN cd /tmp && mkdir libtc && cd libtc \
 && git clone https://github.com/niclabs/tchsm-libtc.git \
 && cd tchsm-libtc && mkdir build && cd build && cmake .. && make install

RUN wget http://github.com/niclabs/tchsm-libdtc/archive/v0.1.tar.gz \
 && echo 'fea5b5e61430daec2a33a46b002fd3358bf3e9a2  v0.1.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f v0.1.tar.gz && rm v0.1.tar.gz \
 && cd /tmp/tchsm-libdtc-0.1 \
 && mkdir build && cd build \
 && cmake  .. \
 && make install

RUN yum remove -y gcc gcc-c++

FROM centos:6

RUN yum install -y \
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
            openssl-devel \
            sqlite-devel \
            unzip \
            wget
            
RUN cd /tmp && curl -L -O http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz \
            && tar zxf autoconf-2.69.tar.gz \
            && cd autoconf-2.69 \
            && ./configure \
            && make && make install \
            && cd /tmp
            && rm -rf autoconf-2.69

RUN curl -L https://people.centos.org/tru/devtools-2/devtools-2.repo -o /etc/yum.repos.d/devtools-2.repo && yum install -y devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++

ENV PKG_CONFIG_PATH ${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig
ENV CXX /opt/rh/devtoolset-2/root/usr/bin/g++
ENV CC /opt/rh/devtoolset-2/root/usr/bin/cc

RUN mkdir gpg_keys

COPY gpg_keys/ gpg_keys/

RUN gpg --import /gpg_keys/botan.gpg /gpg_keys/libsodium.gpg

RUN cd /tmp && git clone git://github.com/jedisct1/libsodium.git && cd libsodium && git checkout e2a30a && ./autogen.sh && ./configure && make check && make install && ldconfig

RUN cd /tmp && git clone --depth 1 git://github.com/zeromq/libzmq.git && cd libzmq && ./autogen.sh && ./configure && make

RUN cd /tmp/libzmq && make install && ldconfig

RUN cd /tmp && rm -rf libzmq libsodium

RUN curl -LO  http://botan.randombit.net/releases/Botan-1.10.17.tgz \
 && curl -LO  http://botan.randombit.net/releases/Botan-1.10.17.tgz.asc \
 && gpg --verify Botan-1.10.17.tgz.asc Botan-1.10.17.tgz \
 && tar -xzC /tmp -f Botan-1.10.17.tgz && rm Botan-1.10.17.tgz \
 && cd /tmp/Botan-1.10.17 && ./configure.py --cc-bin=${CC} && make && make install \
 && ldconfig \
 && cd / && rm -r /tmp/Botan-1.10.17

RUN curl -L 'https://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmhash%2Ffiles%2Fmhash%2F0.9.9.9%2Fmhash-0.9.9.9.tar.gz%2Fdownload%3Fuse_mirror%3Dautoselect&ts=1551892142&use_mirror=autoselect' -o mhash-0.9.9.9.tar.gz \ 
 && echo 'c898de5ea60d9e0873a1b73caa031bb1b5797c03  mhash-0.9.9.9.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f mhash-0.9.9.9.tar.gz && rm mhash-0.9.9.9.tar.gz \
 && cd /tmp/mhash-0.9.9.9 && ./configure && make && make install \
 && cd / && rm -r /tmp/mhash-0.9.9.9

RUN wget https://github.com/niclabs/tchsm-libtc/archive/v0.2.tar.gz \
 && echo '83b28ef1c123777f17548228a32fd1f2f42ec2f3  v0.2.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f v0.2.tar.gz && rm v0.2.tar.gz \
 && cd /tmp/tchsm-libtc-0.2 && mkdir build \
 && cd build && cmake -DBUILD_TESTING=OFF .. && make install \
 && cd / && rm -r /tmp/tchsm-libtc-0.2
 
RUN wget http://github.com/niclabs/tchsm-libdtc/archive/v0.1.tar.gz \
 && echo 'fea5b5e61430daec2a33a46b002fd3358bf3e9a2  v0.1.tar.gz' | sha1sum -c \
 && tar -xzC /tmp -f v0.1.tar.gz && rm v0.1.tar.gz \
 && cd /tmp/tchsm-libdtc-0.1 \
 && mkdir build && cd build \
 && cmake  .. \
 && make install

RUN yum remove -y devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++ \
 &&  rm /etc/yum.repos.d/devtools-2.repo

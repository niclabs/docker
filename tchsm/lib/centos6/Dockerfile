FROM centos:6

RUN yum install -y \
            autoconf \
            bzip2 \
            cmake \
            curl \
            json-c-devel \
            git \
            gmp-devel \
            jansson-devel \
            libconfig-devel \
            libedit-devel \
            libsodium-devel \
            libuuid-devel \
            make \
            mhash-devel \
            m4 \
            openssl-devel \
            sqlite-devel \
            unzip \
            wget \
            zeromq-devel
            

RUN curl -L https://people.centos.org/tru/devtools-2/devtools-2.repo -o /etc/yum.repos.d/devtools-2.repo && yum install -y devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++

ENV PKG_CONFIG_PATH ${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig

ENV CXX /opt/rh/devtoolset-2/root/usr/bin/g++
ENV CC /opt/rh/devtoolset-2/root/usr/bin/cc

COPY gpg_keys/ gpg_keys/

RUN curl -LO  http://botan.randombit.net/releases/Botan-1.10.17.tgz \
	 && curl -LO  http://botan.randombit.net/releases/Botan-1.10.17.tgz.asc \
	 && gpg --verify Botan-1.10.17.tgz.asc Botan-1.10.17.tgz \
	 && tar -xzC /tmp -f Botan-1.10.17.tgz && rm Botan-1.10.17.tgz \
	 && cd /tmp/Botan-1.10.17 && ./configure.py --cc-bin=${CC} && make && make install \
	 && ldconfig \
	 && cd / && rm -r /tmp/Botan-1.10.17
             
RUN git clone https://github.com/niclabs/tchsm-libtc.git \
    && cd tchsm-libtc \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make install 
 
RUN git clone https://github.com/niclabs/tchsm-libdtc.git \
    && cd tchsm-libdtc \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make install 

RUN yum remove -y devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++ \
 &&  rm /etc/yum.repos.d/devtools-2.repo

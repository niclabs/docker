FROM tchsm-lib-ubuntu14:latest

MAINTAINER Francisco Montoto <montoto@niclabs.cl>

RUN apt-get install -y autotools-dev \
                       build-essential \
                       curl \
                       gcc \
                       g++ \
                       libedit-dev \
                       libidn11-dev \
                       libgmp-dev \
                       libjansson-dev \
                       pkg-config

RUN curl -LO http://ftp.gnu.org/gnu/libtasn1/libtasn1-4.7.tar.gz \
 && tar -xzC /tmp -f libtasn1-4.7.tar.gz && rm libtasn1-4.7.tar.gz \
 && cd /tmp/libtasn1-4.7 && ./configure && make && make install \
 && cd / && rm -r /tmp/libtasn1-4.7

RUN curl -LO ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz \
 && tar -xzC /tmp -f libffi-3.2.1.tar.gz && rm libffi-3.2.1.tar.gz \
 && cd /tmp/libffi-3.2.1 && ./configure && make && make install \
 && cd / && rm -r /tmp/libffi-3.2.1

ENV PKG_CONFIG_PATH /usr/local/lib64/pkgconfig/:/usr/local/lib/pkgconfig

RUN curl -LO https://github.com/p11-glue/p11-kit/releases/download/0.23.14/p11-kit-0.23.14.tar.gz \
 && tar -xzC /tmp -f p11-kit-0.23.14.tar.gz && rm p11-kit-0.23.14.tar.gz \
 && cd /tmp/p11-kit-0.23.14 && ./configure && make && make install \
 && cd / && rm -r /tmp/p11-kit-0.23.14

RUN curl -LO https://ftp.gnu.org/gnu/nettle/nettle-3.2.tar.gz \
 && tar -xzC /tmp -f nettle-3.2.tar.gz && rm nettle-3.2.tar.gz \
 && cd /tmp/nettle-3.2 && ./configure && make && make install \
 && cd / && rm -r /tmp/nettle-3.2

RUN curl -LO https://www.gnupg.org/ftp/gcrypt/gnutls/v3.4/gnutls-3.4.9.tar.xz \
 && tar -xC /tmp -f gnutls-3.4.9.tar.xz && rm gnutls-3.4.9.tar.xz \
 && cd /tmp/gnutls-3.4.9 && ./configure && make && make install \
 && cd / && rm -r /tmp/gnutls-3.4.9

RUN curl -O https://lttng.org/files/urcu/userspace-rcu-0.9.2.tar.bz2 \
 && tar -xjC /tmp -f userspace-rcu-0.9.2.tar.bz2 \
 && cd /tmp/userspace-rcu-0.9.2 && ./configure && make && make install \
 && cd / && rm -r /tmp/userspace-rcu-0.9.2

RUN curl -LO https://secure.nic.cz/files/knot-dns/knot-2.2.1.tar.xz \
 && tar -xC /tmp -f knot-2.2.1.tar.xz && rm knot-2.2.1.tar.xz \
 && cd /tmp/knot-2.2.1 && ./configure && make && make install \
 && cd / && rm -r /tmp/knot-2.2.1

RUN apt-get purge -y autotools-dev \
                     build-essential \
                     curl \
                     gcc \
                     g++ \
                     libedit-dev \
                     libidn11-dev \
                     libgmp-dev \
                     libjansson-dev \
                     pkg-config

CMD ["/root/knot_conf/run.sh"]

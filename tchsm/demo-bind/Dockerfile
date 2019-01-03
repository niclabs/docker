FROM tchsm-lib-centos7:latest

RUN yum install -y make perl gcc

RUN yum install -y \
            wget \
            perl-Net-SSLeay \
            openssl \
            perl-IO-Tty \
            perl-Encode-Detect

RUN yum install -y install geoip-devel krb5-devel libcap-devel

RUN yum install -y openssl-devel libxml2-devel sqlite-devel

RUN wget http://prdownloads.sourceforge.net/webadmin/webmin-1.900-1.noarch.rpm \
 && rpm -U webmin-1.900-1.noarch.rpm && rm -f webmin-1.900-1.noarch.rpm

ENV BIND_VERSION=9.11.5-P1 \
  OPENDNSSEC_VERSION=1.4.14 \
  LDNS_VERSION=1.6.17

RUN wget ftp://ftp.isc.org/isc/bind9/${BIND_VERSION}/bind-${BIND_VERSION}.tar.gz \
 && tar -xzf bind-${BIND_VERSION}.tar.gz && rm -f bind-${BIND_VERSION}.tar.gz \
 && cd bind-${BIND_VERSION} && ./configure \
    --prefix=/usr \
    --libdir=\${prefix}/lib/x86_64-linux-gnu \
    --sysconfdir=/etc/bind \
    --enable-threads \
    --with-libtool \
    --enable-shared \
    --with-openssl=/usr \
    --with-gssapi=/usr \
    --with-gnu-ld \
    --with-geoip=/usr \
    --enable-ipv6 \
    --enable-filter-aaaa \
 && make install && cd / && rm -rf bind-${BIND_VERSION} \
 && mkdir /var/bind

RUN wget https://www.nlnetlabs.nl/downloads/ldns/ldns-${LDNS_VERSION}.tar.gz \
  && tar -xzf ldns-${LDNS_VERSION}.tar.gz && rm -f ldns-${LDNS_VERSION}.tar.gz \
  && cd ldns-${LDNS_VERSION} && ./configure --disable-gost && make install \
  && cd / && rm -rf ldns-${LDNS_VERSION}

RUN wget https://dist.opendnssec.org/source/opendnssec-${OPENDNSSEC_VERSION}.tar.gz \
 && tar -xzf opendnssec-${OPENDNSSEC_VERSION}.tar.gz && rm -f opendnssec-${OPENDNSSEC_VERSION}.tar.gz \
 && cd opendnssec-${OPENDNSSEC_VERSION} && ./configure && make install \
 && cd / && rm -rf opendnssec-${OPENDNSSEC_VERSION} 

ENTRYPOINT ["/usr/sbin/named"]

CMD ["-g"]

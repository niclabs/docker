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

ENV OPENDNSSEC_VERSION=1.4.14 \
  LDNS_VERSION=1.6.17

RUN wget https://www.nlnetlabs.nl/downloads/ldns/ldns-${LDNS_VERSION}.tar.gz \
  && tar -xzf ldns-${LDNS_VERSION}.tar.gz && rm -f ldns-${LDNS_VERSION}.tar.gz \
  && cd ldns-${LDNS_VERSION} && ./configure --disable-gost && make install \
  && cd / && rm -rf ldns-${LDNS_VERSION}

# Enable RSyslogs on CentOS, start service by runnig the command "rsyslogd"
RUN yum -y install rsyslog && cd /etc && rm -f rsyslog.d/listen.conf && rm -f rsyslog.conf \
 && wget https://raw.githubusercontent.com/rsyslog/rsyslog-docker/master/base/centos7/rsyslog.conf

RUN wget https://dist.opendnssec.org/source/opendnssec-${OPENDNSSEC_VERSION}.tar.gz \
 && tar -xzf opendnssec-${OPENDNSSEC_VERSION}.tar.gz && rm -f opendnssec-${OPENDNSSEC_VERSION}.tar.gz \
 && cd opendnssec-${OPENDNSSEC_VERSION} && ./configure && make install \
 && cd / && rm -rf opendnssec-${OPENDNSSEC_VERSION}

ENV TCHSM_CONFIG=/cryptoki_TCHSM.conf
RUN ods-ksmutil setup <<< "y"

ENTRYPOINT ["/usr/local/sbin/ods-control"]

CMD ["start"]

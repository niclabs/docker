#### OpenDNSSEC

The docker use [OpenDNSSEC](https://www.opendnssec.org/) because provides a implementation of PKCS#11 how is easy to use and config. The follow config are include in the dockerfile but if you wanna debug something in the following  steps it describe the installation of the depencies separatly.

##### Installation on Ubuntu 18.04

Execute the follow commands

```
export OPENDNSSEC_VERSION=1.4.14
sudo apt-get -y install libxml2-dev libldns-dev libsqlite3-dev sqlite3
wget https://dist.opendnssec.org/source/opendnssec-${OPENDNSSEC_VERSION}.tar.gz
tar -xzf opendnssec-${OPENDNSSEC_VERSION}.tar.gz
rm opendnssec-${OPENDNSSEC_VERSION}.tar.gz
cd opendnssec-${OPENDNSSEC_VERSION}
./configure
make
sudo make install
cd ..
rm -r opendnssec-${OPENDNSSEC_VERSION}
```

#### Installation on CentOS 7
Execute the follow commands

```
export OPENDNSSEC_VERSION=1.4.14
yum -y -q install gcc wget perl make
yum -y -q install openssl-devel libxml2-devel mysql mysql-devel

export LDNS_VERSION=1.6.17
wget https://www.nlnetlabs.nl/downloads/ldns/ldns-${LDNS_VERSION}.tar.gz
tar -xzf ldns-${LDNS_VERSION}.tar.gz
rm -f ldns-${LDNS_VERSION}.tar.gz
cd ldns-${LDNS_VERSION}
./configure --disable-gost
make install
cd ..
rm -rf ldns-${LDNS_VERSION}

wget https://dist.opendnssec.org/source/opendnssec-${OPENDNSSEC_VERSION}.tar.gz
tar -xzf opendnssec-${OPENDNSSEC_VERSION}.tar.gz
rm -f opendnssec-${OPENDNSSEC_VERSION}.tar.gz
cd opendnssec-${OPENDNSSEC_VERSION}
./configure --with-database-backend=mysql
make install
cd ..
rm -rf opendnssec-${OPENDNSSEC_VERSION}
```

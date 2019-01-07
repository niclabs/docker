# TCHSM with BIND and native PKCS#11


The lastest versions of BIND include native PKCS#11 mode in Ubuntu 18.04, but enabling throws a startup fatal error. This error was reported and the comunity decided to include a [patch](https://pagure.io/fedora-bind/c/3d5ea105bd877f0069452e450320f8877b01cb52?branch=master) in the new versions. Unfortunately the patch implemented doesn't work on Ubuntu Bionic and we find the same error when we try to set up BIND in CentOS 7.

Startup crash:
```
02-Jan-2019 14:44:10.000 md5.c:97: fatal error:
02-Jan-2019 14:44:10.000 RUNTIME_CHECK(pk11_get_session(ctx, OP_DIGEST, 1, 0, 0, ((void *)0), 0) == 0) failed
02-Jan-2019 14:44:10.000 exiting (due to fatal error in library)
Aborted (core dumped)
```

This error was reported as a bug of [freeipa package](https://bugs.launchpad.net/ubuntu/+source/freeipa/+bug/1769440) installation. You can see the patch changes [here](https://pagure.io/fedora-bind/c/3d5ea105bd877f0069452e450320f8877b01cb52?branch=master). The fix was confirm in the version [9.11.3+1ubuntu1.3](https://launchpad.net/ubuntu/+source/bind9/1:9.11.3+dfsg-1ubuntu1.3).

For reproduce the error you can follow the next steps:

###### CentOS 7

Install BIND excuting the follow commands, remember to choose a version that includes native PKCS#11 (>= 9.10.X).

```
export BIND_VERSION=9.11.5-P1
yum -y install gcc wget perl make
yum -y install geoip-devel krb5-devel libcap-devel
wget ftp://ftp.isc.org/isc/bind9/${BIND_VERSION}/bind-${BIND_VERSION}.tar.gz
tar -xzf bind-${BIND_VERSION}.tar.gz
rm -f bind-${BIND_VERSION}.tar.gz
cd bind-${BIND_VERSION}
./configure --prefix=/usr \
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
    --enable-native-pkcs11 \
    --with-pkcs11=\${prefix}/lib/x86_64-linux-gnu/softhsm/libsofthsm2.so
sudo make install
cd ..
rm -rf bind-${BIND_VERSION}
```
Now try to startup with the command

```
/usr/sbin/named -g
```


###### UBUNTU 18.04

Install BIND excuting the follow commands, remenber to choose a version that includes native PKCS#11.

Then excecute the follow commands
```
export BIND_VERSION=9.11.5-P1
sudo apt-get install -y gcc wget
sudo apt-get install -y libgeoip-dev libkrb5-dev libcap-dev
wget ftp://ftp.isc.org/isc/bind9/${BIND_VERSION}/bind-${BIND_VERSION}.tar.gz
tar -xzvf bind-${BIND_VERSION}.tar.gz
rm bind-${BIND_VERSION}.tar.gz
cd bind-${BIND_VERSION}
./configure --prefix=/usr \
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
    --enable-native-pkcs11 \
    --with-pkcs11=\${prefix}/lib/x86_64-linux-gnu/softhsm/libsofthsm2.so
make install
cd ..
rm -r bind-${BIND_VERSION}
```
Now try to startup with the command

```
/usr/sbin/named -g
```


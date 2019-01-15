# tchsm docker files

## Threshold Cryptography Distributed HSM
Distributed software emulation of a Hardware Security Module implementing the
PKCS#11 API. Project available at 
[github.com/niclabs/tchsm-libdtc](https://www.github.com/niclabs/tchsm-libdtc)

## Description
This folder contains Dockerfile definitions, it's intended to demonstrate how
to build, configure and run the software. It also provides some ready-to-run
demonstrations of the software used as DNSSEC cryptographic backend in DNS servers.

## Content

### lib
Dockerfiles of the library, vanilla OS with the library installed.

### node
Dockerfiles of the node, vanilla OS with the nodes installed.

### node-webadmin
Webadmin application to manage a single node.

### [demo-knot](https://github.com/npinochet/docker/tree/update-tchsm/tchsm/demo-knot)
Demonstration of the software running simple nodes with one DNS server using [KNOT](https://www.knot-dns.cz/), it includes scripts to run the demo easily.

### [demo-bind](https://github.com/npinochet/docker/tree/update-tchsm/tchsm/demo-bind)
Demonstration of the software running simple nodes with one DNS server using [BIND](https://www.isc.org/downloads/bind/) and [OpenDNSSEC](https://www.opendnssec.org/), it includes scripts to run the demo easily.

### demo-with-node-webadmin
Demonstration of the software running webadmin nodes with one DNS servers using KNOT, it includes scripts to run the demo easily.

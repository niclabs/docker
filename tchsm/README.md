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

### demo
Demonstration of the software running with some DNS servers, it includes scripts to run the demo easily.

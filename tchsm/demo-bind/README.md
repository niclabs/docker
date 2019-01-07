
# TCHSM Demo

# Demo of a DNS server with DNSSEC support using the TCHSM
Docker based demo of the TCHSM as cryptographic backend on BIND and [OpenDNSSEC](opendnssec.md). The demo uses the PKCS#11 implementation of OpenDNSSEC because the [native implementation of BIND have problems](bind_problems_PKCS11.md).

# Overview
This implementation of TCHSM work with BIND and OpenDNSSEC cooperatively, it uses BIND to manage DNS Server and OpenDNSSEC to support DNSSEC using TCHSM as an HSM to store keys. The demo include in the dokerfile installation of OpenDNSSEC, BIND and Webmin, for default it working with CentOS 7.

## Run the Demo

There is an included script to build and run the demo.

To build, execute: ```demo.sh build```

To start the demo: ```demo.sh start```

To stop the demo: ```demo.sh stop```

## Details 

The demo will start 4 docker containers, three of them are nodes and the fourth is a dns server serving a dummy example.com zone, using TCHSM as backend to sign the DNSSEC records. Docker is configured to expose the DNS server in the port 54 of the host computer, you can modify it at the demo.sh script.

### Nodes

Each node is an instance of our `tchsm-node-alpine` docker container run with the following command, which also mounts the node's config file into the container:

```
docker -D run --net=tchsm -d -v /full/path/to/node$i.conf:/etc/node$i.conf --name node-$i tchsm-node-alpine -c /etc/node$i.conf
```

Each node's config file looks like this:
```
node:
{
	masters = (
		{
		public_key="peE<k[?.}r>kaxZ?Bxsb/S0C?I3HDjp0>x!YSsht",
		id="MASTER_MOCK_ID1"
		}
	)
	router_port=2121,
	sub_port=2122,
	database="/etc/node_1.db",
	private_key="3Dl<rS3qN+{1#*HL[z<VNy7kFw-aU/+iL^1fxU.l",
	public_key="Xp0%>K&/mGA+Y!=-gtX2?.N&!C-)ag5xPhKbK).@",
	interface="*"
}
```

The file specifies the master's public key and id as well as the ports the node will listen on and it's own public and private keys for signing. These files can be generated using the `create_config.py` script from [https://github.com/niclabs/tchsm-libdtc](https://github.com/niclabs/tchsm-libdtc). The config files used for the demo were created with the following options:

```
python create_config.py -db "/etc/node" -cdb "/etc/tchsm-cryptoki" "node-1":2121:2122 "node-2":2123:2124 "node-3":2125:2126
```

To see how to configure and run a single node see [our node web admin](https://github.com/niclabs/docker/tree/master/tchsm/node-webadmin).



Before running the server we copy the configuration files from the `conf_files/` directory into the container.
 - `cryptoki.conf`: This file configures the master for the nodes and contains the master public and private keys, it also contains a list of all the nodes including their IP addresses, ports and public keys. 
 - `bind/zones/db.example.com`: File with the example.com DNS records.
 
 // hacer run.sh //
 - `run.sh`: Script to be run by the container on startup. The script configures the knot server top use the tchsm version of the libpkcs11.so library, then generates the keys for the example.com zone and finally starts the knot server.


### How to test DNSSEC validation

Run this command for check if the DNS domain if effectively DNSSEC signed,there exist three types of anwsers.

```
dig pir.org +dnssec +multi
```
**1.** Requesting a DNSSEC singed DNS domain should return an answer including the AD-Flag (Authenticated answer) set in the header and NOERROR in status. 

###### Example:

```
; <<>> DiG 9.11.3-1ubuntu1.3-Ubuntu <<>> dnssec-tools.org +dnssec
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 63414
;; flags: qr rd ra ad; QUERY: 1, ANSWER: 5, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags: do; udp: 512
;; QUESTION SECTION:
;dnssec-tools.org. IN A

;; ANSWER SECTION:
dnssec-tools.org. 299 IN A 185.199.108.153
dnssec-tools.org. 299 IN A 185.199.111.153
dnssec-tools.org. 299 IN A 185.199.109.153
dnssec-tools.org. 299 IN A 185.199.110.153
dnssec-tools.org. 299 IN RRSIG A 5 2 300 20190119070442 20181220060442 3147 dnssec-tools.org. 3sMncOyxuHFvoh0GGqkeyom8kIq5k6HpuAjgW/yz7yeH5KhRXUZuokg1 eWxgzigWB3/8sQD/acRtiTgPaQbGdduSy9RkKJs65QRwUvENt45J7qpg lfA8m4p3+50iekvsFOAbRinDaTObivOFeML7IinRSl1e64VxHfIKR/Rj Uqs=

;; Query time: 356 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Mon Jan 07 18:08:59 UTC 2019
;; MSG SIZE rcvd: 285

``` 


**2.** Broken DNS Domain should return SERVFAIL in status:
``` 
; <<>> DiG 9.11.3-1ubuntu1.3-Ubuntu <<>> dnssec.fail +dnssec
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, id: 59255
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags: do; udp: 512
;; QUESTION SECTION:
;dnssec.fail. IN A

;; Query time: 277 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Mon Jan 07 18:06:44 UTC 2019
;; MSG SIZE rcvd: 40
``` 
###### Example: 

**3.** Requesting a domain that is not DNSSEC signed should return NOERROR in status.

######  Example:
``` 
niclabs@user:/etc$ dig www.google.com +dnssec +multi

; <<>> DiG 9.11.3-1ubuntu1.3-Ubuntu <<>> www.google.com +dnssec +multi
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50388
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags: do; udp: 65494
;; QUESTION SECTION:
;www.google.com.		IN A

;; ANSWER SECTION:
www.google.com.		59 IN A	64.233.190.147
www.google.com.		59 IN A	64.233.190.106
www.google.com.		59 IN A	64.233.190.105
www.google.com.		59 IN A	64.233.190.104
www.google.com.		59 IN A	64.233.190.103
www.google.com.		59 IN A	64.233.190.99

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Jan 07 
``` 

### Benchmark 

For testing opendnssec we use https://github.com/opendnssec/p11speed

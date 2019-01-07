
# TCHSM Demo

# Demo of a DNS server with DNSSEC support using the TCHSM
Docker based demo of the TCHSM as cryptographic backend on BIND and [OpenDNSSEC](opendnssec.md). The demo uses the PKCS#11 implementation of OpenDNSSEC because the [native implementation of BIND have problems](problems_bind_pkcs11.md).


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

### DNS Server

The DNS Server runs an extension of the `tchsm lib` container which also has [BIND](https://www.isc.org/downloads/bind/) and [OpenDNSSEC](opendnssec.md) installed.

The OpenDNSSEC DNS server uses the tchsm library as cryptographic backend for signing.


/change/ 



The demo only signs the exmaple.com zone manually, the knot server configuration is not intended to be used in production. For a full explanation of how to configure the knot server see [https://www.knot-dns.cz/docs/2.5/html/configuration.html](https://www.knot-dns.cz/docs/2.5/html/configuration.html)


Before running the server we copy the configuration files from the `conf_files/bind` directory into the container.
 - `cryptoki.conf`: This file configures the master for the nodes and contains the master public and private keys, it also contains a list of all the nodes including their IP addresses, ports and public keys.
 - `knot.conf`: This file configures the knot DNS server. It specifies the port the server will listen, and the zones it will sign. In the demo we will only sign a dummy example.com manually.
 - `example.com`: File with the example.com DNS records.
 - `run.sh`: Script	to be run by the container on startup. The script configures the knot server top use the tchsm version of the libpkcs11.so library, then generates the keys for the example.com zone and finally starts the knot server.

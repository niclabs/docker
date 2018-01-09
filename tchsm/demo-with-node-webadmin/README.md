# TCHSM Demo

# Demo of a DNS server with DNSSEC support using the TCHSM
Docker based demo of the TCHSM as cryptographic backend for a knot DNS server implementing DNSSEC.

## Run the Demo

There is an included script to build and run the demo.

To build, execute: ```demo.sh build```

To start the demo: ```demo.sh start```

To stop the demo: ```demo.sh stop```

## Details

The demo will start 4 docker containers, three of them are nodes running the node admin application to configure the node's master and the fourth is a dns server serving a dummy example.com zone, using TCHSM as backend to sign the DNSSEC records. Docker is configured to expose the DNS server in the port 54 of the host computer, you can modify it at the demo.sh script.

### Nodes

Each node is an instance of our `node-webadmin` docker container run with the following command, which also mounts the node's config file into the container:

```
docker run -d -v ${CONF_DIR}/${NODEADMIN_CONF}:/home/nodeadmin/tchsm-nodeadmin/conf/node.conf \
            -v ${CONF_DIR}/start.sh:/home/nodeadmin/tchsm-nodeadmin/conf/start.sh \
            -v ${CONF_DIR}/${NODEADMIN_CONF_PY}:/home/nodeadmin/tchsm-nodeadmin/config.py \
            --name $CONTAINER_NAME --net=tchsm -e "NODEADMIN_HTTP=1" \
            -p 0.0.0.0:${EXPOSE_HTTP_PORT}:80 -p 0.0.0.0:${EXPOSE_NODE_ROUTER_PORT}:${EXPOSE_NODE_ROUTER_PORT} \
            -p 0.0.0.0:${EXPOSE_NODE_SUB_PORT}:${EXPOSE_NODE_SUB_PORT} tchsm-nodeadmin

```
The command mounts the configuration files and start script into the container as volumes and exposes ports for communicating with the master, and for the nodeadmin application.

#### Node configuration

Each node has two configuration files `node_i.conf` and `config_i.py`. They can be created using the `demo.sh make-config`, the files will also be created by the `demo.sh start` command if they don't exist already. You can change the `NODES` variable in the `demo.sh` script to set the number of nodes the example will use, the script will create the necessary amount of configuration files.

The `node_i.conf` files look like this:
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
The file specifies the master's public key and id as well as the ports the node will listen on and it's own public and private keys for signing. In order to create the `node_i.conf` files the script uses `create_config.py` from [https://github.com/niclabs/tchsm-libdtc](https://github.com/niclabs/tchsm-libdtc) to generate the signing keys.

The `config_i.py` files look like this:
```
class DefaultConfig(object):
    DEBUG = True
    CSRF_ENABLED = True
    SECRET_KEY = 'app secret key'
    SQLALCHEMY_DATABASE_URI = 'sqlite:////etc/node_n.db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    NODE_PUBLIC_KEY = 'node public key'
    ADMIN_EMAIL = 'admin@mail.com'
    ADMIN_PASSWORD = 'secret-password'

```
The file specifies the location of the local key database and the credentials for the admin user.

To see how to configure and run a single node see [our node web admin](https://github.com/niclabs/docker/tree/master/tchsm/node-webadmin).

### DNS Server

The DNS Server runs an extension of the `tchsm lib` container which also has [Knot-DNS](https://www.knot-dns.cz/) installed.
The Knot DNS server uses the tchsm library as cryptographic backend for signing.

The demo only signs the exmaple.com zone manually, the knot server configuration is not intended to be used in production. For a full explanation of how to configure the knot server see [https://www.knot-dns.cz/docs/2.5/html/configuration.html](https://www.knot-dns.cz/docs/2.5/html/configuration.html)

Before running the server we copy the configuration files from the `conf_files/knot` directory into the container.
 - `cryptoki.conf`: This file configures the master for the nodes and contains the master public and private keys, it also contains a list of all the nodes including their IP addresses, ports and public keys.
 - `knot.conf`: This file configures the knot DNS server. It specifies the port the server will listen, and the zones it will sign. In the demo we will only sign a dummy example.com manually.
 - `example.com`: File with the example.com DNS records.
 - `demo.sh`: Script	to be run by the container on startup. The script configures the knot server top use the tchsm version of the libpkcs11.so library, then generates the keys for the example.com zone and finally starts the knot server.

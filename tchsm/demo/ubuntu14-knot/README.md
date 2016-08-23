# TCHSM Demo

# Demo of an DNS server with DNSSEC support using the TCHSM
Docker based demo of the TCHSM as cryptographic backend for a knot DNS server implementing DNSSEC.

## Run the Demo

There is an included script to build and run the demo.

To build, execute: ```demo.sh build```

To start the demo: ```demo.sh start```

To stop the demo: ```demo.sh stop```

The demo will start 4 docker containers, three of them will be nodes and the fourth will be a dns server serving a dummy example.com zone, using TCHSM as backend to sign the DNSSEC records. Docker is configured to expose the DNS server in the port 54 of the host computer, you can modify it at the demo.sh script.

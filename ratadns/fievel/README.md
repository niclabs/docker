RataDNS / Fievel Docker file
=================================

The current folder has the Dockerfiles used to build fievel's image.

# How to build

Run `docker build -t ratadns-fievel-demo .` in the same folder that has the Dockerfile.

# How to run

In order to run gopher is needed to have a redis server running with the hostname
redis (thinking in docker _link_).

If the redis server runs in a container named _redis_, then follow the instructions below:
`
docker run --link redis --name ratadns-fievel-demo ratadns-fievel-demo
`

# How to override the prers or configuration file

Just use the `-v` command line option when doing `docker run`:
`
docker run -v config-file:/etc/fievel.json -v folder-of-prers:/var/fievel/prers --link redis --name ratadns-fievel ratadns-fievel
`

(Don't hesitate using the redis options that you want, such as --restart=unless-stopped or -d)

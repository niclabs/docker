FROM tchsm-lib-ubuntulatest:latest

MAINTAINER Francisco Montoto <montoto@niclabs.cl>

RUN apt-get update -qq && apt-get install --no-install-recommends -y software-properties-common

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:cz.nic-labs/knot-dns \
 && apt-get update \
 && apt-get install --no-install-recommends -y knot

CMD ["/root/knot_conf/run.sh"]

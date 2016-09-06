#!/usr/bin/env bash

set -e

mkdir /root/kasp && cd /root/kasp

export TCHSM_CONFIG=/root/knot_conf/cryptoki.conf

knotd -c /root/knot_conf/knot.conf

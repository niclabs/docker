#!/usr/bin/env bash

set -e

mkdir /root/kasp && cd /root/kasp

# export KEYMGR_DIR=/root/kasp
export TCHSM_CONFIG=/root/knot_conf/cryptoki.conf

knotd -v -c /root/knot_conf/knot.conf

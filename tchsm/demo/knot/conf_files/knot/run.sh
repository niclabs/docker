#!/usr/bin/env bash

mkdir /root/kasp && cd /root/kasp && keymgr init

export KEYMGR_DIR=/root/kasp
export TCHSM_CONFIG=/root/knot_conf/cryptoki.conf

# Creates a keystore that would use tchsm
keymgr keystore add tchsm-keystore backend pkcs11 config "pkcs11:token=TCBHSM;pin-value=1234 /usr/local/lib/libpkcs11.so"

# Create a signing policy names tchsm-policy with disabled automatic key managment
keymgr policy add tchsm-policy manual true \
                               keystore tchsm-keystore \
                               algorithm 8 \
                               zsk-size 1024 \
                               ksk-size 1024

# Create a zone entry for the example.com zone with the created policy.
keymgr zone add example.com policy tchsm-policy

# Generate the keys
keymgr zone key generate example.com algorithm RSASHA256 size 1024
keymgr zone key generate example.com algorithm RSASHA256 size 1024 ksk
knotd -c /root/knot_conf/knot.conf

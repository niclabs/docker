#!/usr/bin/env bash

openssl req -newkey rsa:2048 -sha256 -nodes -keyout key.pem -x509 -days 365 -out cert.pem -subj "/C=CL/ST=Metropolitana/L=Santiago/O=NICLabsChile/CN=127.0.0.1"

FROM nginx:latest
MAINTAINER Francisco Cifuentes

RUN apt-get update && apt-get install -y git 

COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir /ratadns && \
	cd /ratadns && \
	git clone https://github.com/niclabs/ratadns-remy.git && \
	cd ratadns-remy && \
	git checkout newviz

COPY config.js /ratadns/ratadns-remy/js/config.js


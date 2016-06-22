FROM python:3-slim
MAINTAINER Francisco Cifuentes

#install gcc
RUN apt-get update && \
	apt-get install gcc make -y

#install git
RUN apt-get install git -y

#install uwsgi
RUN pip install uwsgi

#Clone project
RUN mkdir /ratadns && \
	cd /ratadns && \
	git clone https://github.com/niclabs/ratadns-gopher.git && \
	cd ratadns-gopher && \
	git checkout 9913cd7

COPY config.json /ratadns/ratadns-gopher/config.json

#install dependencies
RUN cd /ratadns/ratadns-gopher && \
	pip install -r requirements.txt

#remove unnecessary things
RUN apt-get remove git gcc make -y

#run 
CMD cd /ratadns/ratadns-gopher && \
        uwsgi --socket 0.0.0.0:8000  -w gopher:app

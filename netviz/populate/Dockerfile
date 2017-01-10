## Header
FROM mdillon/postgis:9.5
#FROM postgres:9.5
MAINTAINER Felipe Quintanilla <felipe@niclabs.cl>


## Dependencies
# install apt dependencies
RUN apt-get update && \
	apt-get install -y git curl

# clone project
RUN mkdir /netviz && \
	cd /netviz && \
	git clone https://github.com/niclabs/net-viz.git && \
	cd net-viz && \
	git checkout 5ca8fecd4b00b3468b919b0329d52dabf930a3fd


## Clean Up
# cleaning up apt dependencies
RUN apt-get purge -y \
    git \
		curl

# cleaning up list of available packages
RUN rm -rf /var/lib/apt/lists/*


## Run command
# put migrate files in docker-entrypoint-initdb.d folder
# so they will be run on database initialization

WORKDIR /netviz/net-viz/app/db_migrations

RUN mv cables_ficticios.sql 03.5_cables_ficticios.sql
RUN ls | grep tar.gz | xargs tar xzf

RUN cp *.sql /docker-entrypoint-initdb.d/

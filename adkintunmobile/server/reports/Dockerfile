## Header
FROM python:3.5.1-slim
MAINTAINER Javier Morales

## Dependencies
# install apt dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		gcc \
		git \
		libpq-dev \
		make

# clone project
RUN mkdir /adk && \
	cd /adk && \
	git clone https://github.com/niclabs/adkintun-reports && \
	cd adkintun-reports

# install pip dependencies
RUN cd /adk/adkintun-reports && \
	pip install -r requirements.txt

## Clean Up
# cleaning up apt dependencies
RUN apt-get purge -y \
    gcc \
    git \
    libpq-dev \
    make

# cleaning up list of available packages
RUN rm -rf /var/lib/apt/lists/*

## Run command
#run uwsgi
CMD cd /adk/adkintun-reports && \
uwsgi --socket 0.0.0.0:8000 --processes $(nproc) -w app:application --mule


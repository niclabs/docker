## Header
FROM python:3.5.1-slim
MAINTAINER Boris Romero <boris@niclabs.cl>


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
	git clone https://github.com/niclabs/AdkintunMobile-Server.git && \
	cd AdkintunMobile-Server && \
	git checkout cf3a632bfab09e510093199c8d75eed5fac91d71 

# install pip dependencies
RUN cd /adk/AdkintunMobile-Server && \
	pip install -r requirements.txt && \
	pip install uwsgi


## Clean Up
# cleaning up apt dependencies
RUN apt-get purge -y \
    gcc \
    git \
    libpq-dev \
    make

# cleaning up list of available packages
RUN rm -rf /var/lib/apt/lists/*

# cleaning up manage file
RUN cd /adk/AdkintunMobile-Server && \
	rm manage.py


## Run command
#run uwsgi
CMD cd /adk/AdkintunMobile-Server && \
	uwsgi --socket 0.0.0.0:8000  --processes $(nproc) -w app:app

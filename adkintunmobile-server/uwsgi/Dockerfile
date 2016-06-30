## Header
FROM python:3.5.1-slim
MAINTAINER Boris Romero <boris@niclabs.cl>


## Dependencies
# install apt dependencies
RUN apt-get update && \
	apt-get install -y \
		gcc \
		git \
		libpq-dev \
		make \
		wget

# clone project
RUN mkdir /adk && \
	cd /adk && \
	git clone https://github.com/niclabs/AdkintunMobile-Server.git && \
	cd AdkintunMobile-Server && \
	git checkout 451e2637dd7bf15d0574b49d2397e90f548ef6ab 

# install pip dependencies
RUN cd /adk/AdkintunMobile-Server && \
	pip install -r requirements.txt && \
	pip install uwsgi


## Clean Up
# cleaning up apt dependencies
RUN apt-get remove -y \
    gcc \
    git \
    libpq-dev \
    make && \
    rm manage.py


## Run command
#run uwsgi
CMD cd /adk/AdkintunMobile-Server && \
	uwsgi --socket 0.0.0.0:8000  -w app:app

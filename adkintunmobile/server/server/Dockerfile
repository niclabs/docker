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
	git checkout 2894b04522fb195e439dd7dd470b18de2c5d0d46 


# install pip dependencies
RUN cd /adk/AdkintunMobile-Server && \
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
CMD cd /adk/AdkintunMobile-Server && \
	uwsgi --socket 0.0.0.0:8000  --processes $(nproc) -w app:application --mule --mule	

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
	git checkout edd2076129f99d1456aa0f47d1c70442844c5a10 

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
# run migrate
CMD cd /adk/AdkintunMobile-Server && \
	python manage.py db init && \
	python manage.py db migrate && \
	python manage.py db upgrade && \
	python manage.py populate

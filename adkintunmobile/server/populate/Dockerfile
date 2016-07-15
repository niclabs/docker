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
		make \
		wget

# clone project
RUN mkdir /adk && \
	cd /adk && \
	git clone https://github.com/niclabs/AdkintunMobile-Server.git && \
	cd AdkintunMobile-Server && \
	git checkout 6ef38fd6e87695401f0d97bf4f7e9d55361e536a 

# install pip dependencies
RUN cd /adk/AdkintunMobile-Server && \
	pip install -r requirements.txt


## Configuration
# Clone antennas data file
RUN cd /adk/AdkintunMobile-Server/app/data && \
	wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B3bt_QH0DLXzaWNTdDREV1ptcWM' -O initial_data_antennas.py


## Clean Up
# cleaning up apt dependencies
RUN apt-get purge -y \
    gcc \
    git \
    libpq-dev \
    make \
    wget && \
    rm -rf /var/lib/apt/lists/*


## Run command
# run migrate
CMD cd /adk/AdkintunMobile-Server && \
	python manage.py db init && \
	python manage.py db migrate && \
	python manage.py db upgrade && \
	python manage.py populate && \
	python manage.py populate_antennas

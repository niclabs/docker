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
    wget


## Run command
# run migrate
CMD cd /adk/AdkintunMobile-Server && \
	python manage.py db init && \
	python manage.py db migrate && \
	python manage.py db upgrade && \
	python manage.py populate && \
	python manage.py populate_antennas

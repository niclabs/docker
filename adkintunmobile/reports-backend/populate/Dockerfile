## Header
FROM python:3.5.1-slim
MAINTAINER Felipe Quintanilla <felipe@niclabs.cl>

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
	git clone https://github.com/niclabs/adkintunmobile-frontend.git && \
	cd adkintunmobile-frontend && \
	git checkout 7d0070fd04f86ba6dd8fffbea85d13c01f031d36

#RUN mkdir /adk
#COPY adkintun-reports.tar.gz /adk/adkintun-reports.tar.gz
#RUN cd /adk && \
#	tar xzf adkintun-reports.tar.gz

# install pip dependencies
RUN cd /adk/adkintunmobile-frontend && \
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

COPY populate.sh /adk/adkintunmobile-frontend/populate.sh

WORKDIR /adk/adkintunmobile-frontend

## Run command
# run migrate
CMD ["/adk/adkintunmobile-frontend/populate.sh"]

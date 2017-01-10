## Header
FROM python:2.7-slim
MAINTAINER Felipe Quintanilla <felipe@niclabs.cl>


## Dependencies
# install apt dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		gcc \
		g++ \
		git \
		libffi-dev \
		libpq-dev \
		libxml2-dev \
		make \
		python-psycopg2


# clone project
RUN mkdir /netviz && \
	cd /netviz && \
	git clone https://github.com/niclabs/net-viz.git && \
	cd net-viz && \
	git checkout 5ca8fecd4b00b3468b919b0329d52dabf930a3fd

# install pip dependencies
RUN cd /netviz/net-viz && \
	pip install -r requirements.txt
RUN pip install uwsgi


## Clean Up
# cleaning up apt dependencies
RUN apt-get purge -y \
    gcc \
    git \
    make \
		libpq-dev \
		libffi-dev && \
		apt-get autoremove -y

# cleaning up list of available packages
RUN rm -rf /var/lib/apt/lists/*


## Run command
#run uwsgi
CMD cd /netviz/net-viz && \
	uwsgi --socket 0.0.0.0:5000  --processes $(nproc) -w netviz:app --mule --mule

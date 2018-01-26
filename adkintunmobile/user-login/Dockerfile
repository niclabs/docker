FROM node:7.10.0-alpine

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN cd /usr/src/app/ && \
	mkdir tmp && touch tmp/login-ws-adk.log && \
	 npm install

# Bundle app source
COPY . /usr/src/app

USER node
CMD [ "npm", "start" ]


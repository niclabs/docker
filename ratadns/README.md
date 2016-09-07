# RaTA DNS - Docker images

## RaTA DNS

Real time analytics for DNS servers, from the packets capture to the web visualization of the data. Project available [here](https://www.github.com/niclabs/ratadns).

## Description of docker images

This repository contains Dockerfile definitions, intended to build and run every module of RaTA DNS. Also provides a demo for Fievel module.

## Content

### fievel-demo

Dockerfile to create container running an instance of Fievel, using some example .pcaps files. Runs the DNS packets in a loop, simulating DNS traffic.

### fievel

Dockerfile to create container that runs a clean instance of Fievel.

### gopher

Dockerfile to create container that runs an instance of Gopher, exposing port 8000 and using gunicorn as WSGI application container.

### nginx

Dockerfile that runs an nginx server necessary to run web visualization Remy.

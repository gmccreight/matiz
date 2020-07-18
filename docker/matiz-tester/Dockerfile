# This comes from https://hub.docker.com/_/python and is based on Debian Buster
#
# Note that materialize also has their *own* docker container version available
# here: https://materialize.io/docs/install/

FROM python:3.8.3-slim-buster

LABEL author="Gordon McCreight" email="gordon@mccreight.com"
LABEL version="0.1"

RUN apt-get update
RUN apt-get install -y tmux

# materialized acts like Postgres, so you will need psql to interact with it
RUN apt-get install -y postgresql-client

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1

# This comes from https://hub.docker.com/_/python and is based on Debian Buster
#
# Note that materialize also has their *own* docker container version available
# here: https://materialize.io/docs/install/

FROM python:3.8.3-slim-buster

LABEL author="Gordon McCreight" email="gordon@mccreight.com"
LABEL version="0.1"

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y tmux

RUN curl -L https://downloads.mtrlz.dev/materialized-v0.3.1-x86_64-unknown-linux-gnu.tar.gz \
    | tar -xzC /usr/local --strip-components=1

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1

ENTRYPOINT materialized -w 1

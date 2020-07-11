#!/bin/bash

set -e

docker build -t matiz-materialized:latest $(dirname $0)/../docker/matiz-materialized
docker build -t matiz-tester:latest $(dirname $0)/../docker/matiz-tester

#!/bin/bash

docker container ls --all | grep matiz | egrep -o "^[0-9a-f]+" | xargs docker rm

#!/bin/bash

docker rmi matiz-materialized
docker rmi matiz-tester

# Those might fail (like if the images don't exist)
# But that's OK.  This script should look like it succeeds
true

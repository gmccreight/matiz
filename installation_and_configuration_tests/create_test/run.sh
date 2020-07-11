#!/bin/bash

local_dir=$(dirname $0)
container_dir=/installation_and_configuration_tests/create_test

# Cleanup local
rm -rf $local_dir/results
mkdir $local_dir/results

# Setup container
docker exec -ti matiz-tester sh -c "rm -rf $container_dir"
docker exec -ti matiz-tester sh -c "mkdir -p $container_dir/code"
docker exec -ti matiz-tester sh -c "mkdir -p $container_dir/results"
docker cp $local_dir/code/code.py matiz-tester:$container_dir/code/code.py

docker exec -ti matiz-tester sh -c "psql -h matiz-materialized -p 6875 materialize"
# docker cp matiz-tester:$container_dir/results/results.txt $local_dir/results/results.txt
# 
# if [ `cat $local_dir/results/results.txt` -eq 50000000 ]; then
#   echo OK - installation_and_configuration_tests/create_test
# else
#   echo NOT OK - installation_and_configuration_tests/create_test
# fi

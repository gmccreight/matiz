#!/bin/bash

local_dir=$(dirname $0)
container_dir=/installation_and_configuration_tests/materialized_is_running_test

# Cleanup local
rm -rf $local_dir/results
mkdir $local_dir/results

# Setup container
docker exec -ti matiz-tester sh -c "rm -rf $container_dir"
docker exec -ti matiz-tester sh -c "mkdir -p $container_dir/results"

docker exec -ti matiz-tester sh -c "psql -h matiz-materialized -p 6875 materialize -c 'show sources' > $container_dir/results/results.txt"
docker cp matiz-tester:$container_dir/results/results.txt $local_dir/results/results.txt
 
if [ `grep SOURCES $local_dir/results/results.txt` ]; then
  # The psql output contains the uppercase column name SOURCES
  echo OK - installation_and_configuration_tests/materialized_is_running_test
else
  echo NOT OK - installation_and_configuration_tests/materialized_is_running_test
fi

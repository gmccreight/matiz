#!/bin/bash

local_dir=$(dirname $0)
container_dir=/examples/example_020_merge_streams

# Cleanup local
rm -rf $local_dir/results
mkdir $local_dir/results
rm -rf $local_dir/logs
mkdir $local_dir/logs

# Setup container
docker exec -ti matiz-tester sh -c "rm -rf $container_dir"
docker exec -ti matiz-tester sh -c "mkdir -p $container_dir/code"
docker exec -ti matiz-tester sh -c "mkdir -p $container_dir/results"
docker exec -ti matiz-tester sh -c "mkdir -p $container_dir/scratch"
docker exec -ti matiz-tester sh -c "mkdir -p $container_dir/logs"
docker cp $local_dir/code/code.sh matiz-tester:$container_dir/code/code.sh

docker exec -ti matiz-tester sh -c "$container_dir/code/code.sh $container_dir/results/results.txt $container_dir/logs/logs.txt $container_dir/scratch"
docker cp matiz-tester:$container_dir/results/results.txt $local_dir/results/results.txt
docker cp matiz-tester:$container_dir/logs/logs.txt $local_dir/logs/logs.txt

if cmp -s $local_dir/expected_results.txt $local_dir/results/results.txt
then
  echo OK - examples/example_020_merge_streams
else
  echo NOT OK - examples/example_020_merge_streams
fi

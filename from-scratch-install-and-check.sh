#!/bin/bash

# This script cleans up previous installs (if there were any) and then builds
# images and runs the containers.
#
# Then it runs a small set of tests to ensure that the installation worked
# correctly, and that the configuration in the docker-compose.yml has the
# intended effect.
#
# You should expect to see the following at the end of the run:
#
# OK - installation_and_configuration_tests/create_test
#
# After you have established that things are working ok, you can run examples,
# open a console, etc.
#
# Note, to shut down the containers whenever you're done with them, run:
#
# docker-compose down

set -e

dir=$(dirname $0)

$dir/manage/0010-remove-containers.sh
$dir/manage/0020-remove-images.sh
$dir/manage/0030-build-images.sh
$dir/manage/0040-start-containers.sh
# $dir/installation_and_configuration_tests/run.sh

sleep 5
docker exec -ti matiz-tester sh -c "psql -h matiz-materialized -p 6875 materialize"

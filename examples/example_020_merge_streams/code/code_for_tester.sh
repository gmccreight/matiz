#!/bin/bash

result_file=$1
log_file=$2
scratch_dir=$3

stream_1_file=$scratch_dir/stream_1_file
stream_2_file=$scratch_dir/stream_2_file

sleep 1

psql -h matiz-materialized -p 6875 materialize > $log_file << EOF
drop view if exists example_020_stream_1_recentchanges;
drop source if exists example_020_stream_1;
EOF

psql -h matiz-materialized -p 6875 materialize > $log_file << EOF
create source example_020_stream_1
from file '$stream_1_file' with (tail = true)
format regex '^data: (?P<data>.*)';
EOF

psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
create materialized view example_020_stream_1_recentchanges as
    select
        (val->'id')::float::int as id
    from (select data::jsonb as val from example_020_stream_1)
;
EOF

psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
show columns from example_020_stream_1_recentchanges
;
EOF

for i in `seq 1 10`; do
  echo "looking for the recent changes $i" >> $log_file
psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
select count(*) from example_020_stream_1_recentchanges
EOF
sleep 1
done

sleep 1

psql -h matiz-materialized -p 6875 materialize > $result_file << EOF
select count(*) from example_020_stream_1_recentchanges
EOF

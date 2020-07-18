#!/bin/bash

result_file=$1
log_file=$2
scratch_dir=$3

stream_1_file=$scratch_dir/stream_1_file
stream_2_file=$scratch_dir/stream_2_file
stream_3_file=$scratch_dir/stream_3_file

sleep 1

psql -h matiz-materialized -p 6875 materialize > $log_file << EOF
drop view if exists example_020_group_counts_annotated;
drop view if exists example_020_group_counts;
drop view if exists example_020_stream_1_recentchanges;
drop view if exists example_020_stream_2_recentchanges;
drop view if exists example_020_stream_3_recentchanges;
drop source if exists example_020_stream_1;
drop source if exists example_020_stream_2;
drop source if exists example_020_stream_3;
EOF

psql -h matiz-materialized -p 6875 materialize > $log_file << EOF
create source example_020_stream_1
from file '$stream_1_file' with (tail = true)
format regex '^data: (?P<data>.*)';
EOF

psql -h matiz-materialized -p 6875 materialize > $log_file << EOF
create source example_020_stream_2
from file '$stream_2_file' with (tail = true)
format regex '^data: (?P<data>.*)';
EOF

psql -h matiz-materialized -p 6875 materialize > $log_file << EOF
create source example_020_stream_3
from file '$stream_3_file' with (tail = true)
format regex '^data: (?P<data>.*)';
EOF

psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
create materialized view example_020_stream_1_recentchanges as
    select
        (val->'id')::float::int as id,
        val->>'grouping_code' AS grouping_code,
        val->>'code' AS code
    from (select data::jsonb as val from example_020_stream_1)
;
EOF

psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
create materialized view example_020_stream_2_recentchanges as
    select
        (val->'id')::float::int as id,
        val->>'extra_info' as extra_info
    from (select data::jsonb as val from example_020_stream_2)
;
EOF

psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
create materialized view example_020_stream_3_recentchanges as
    select
        (val->'id')::float::int as id,
        val->>'extra_info' as extra_info
    from (select data::jsonb as val from example_020_stream_3)
;
EOF

psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
show columns from example_020_stream_1_recentchanges
;
EOF

psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
create materialized view example_020_group_counts as
select
  grouping_code,
  count(*) as num_codes,
  max(id) as max_id
from example_020_stream_1_recentchanges
group by grouping_code
;
EOF

psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
create materialized view example_020_group_counts_annotated as
select
  g.grouping_code,
  g.num_codes,
  g.max_id,
  s2.extra_info as s2_extra_info,
  s3.extra_info as s3_extra_info
from example_020_group_counts g
left join example_020_stream_2_recentchanges s2 on true
  and s2.id = g.max_id
left join example_020_stream_3_recentchanges s3 on true
  and s3.id = g.max_id
;
EOF


for i in `seq 1 10`; do

#   echo "looking for the recent changes $i - debug"
# 
# psql -h matiz-materialized -p 6875 materialize << EOF
# select *
# from example_020_group_counts_annotated
# order by max_id desc
# limit 10
# EOF

  echo "looking for the recent changes $i - to log" >> $log_file
psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
select *
from example_020_group_counts_annotated
order by max_id desc
limit 10
EOF
sleep 1
done

sleep 1

psql -h matiz-materialized -p 6875 materialize > $result_file << EOF
select
  num_codes,
  s2_extra_info,
  s3_extra_info
from example_020_group_counts_annotated
where grouping_code = '000049'
EOF

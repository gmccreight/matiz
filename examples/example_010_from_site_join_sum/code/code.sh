#!/bin/bash

result_file=$1
log_file=$2

psql -h matiz-materialized -p 6875 materialize > $log_file << EOF
drop view if exists example_010_key_sum;
drop view if exists example_010_pseudo_source;
drop view if exists example_010_lhs;
EOF

psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
create materialized view example_010_pseudo_source (key, value) as
    values
      ('a', 1), ('a', 2), ('a', 3), ('a', 4), -- the ones that are summed up later
      ('b', 5),
      ('c', 6), ('c', 7)
;
EOF

psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
create materialized view example_010_lhs (key, value) as
    values
    ('x', 'a'), -- see how x points to a?
    ('y', 'b'),
    ('z', 'c')
;
EOF

psql -h matiz-materialized -p 6875 materialize >> $log_file << EOF
create materialized view example_010_key_sum (key, sum) as
select lhs.key, sum(rhs.value)
from example_010_lhs as lhs
join example_010_pseudo_source as rhs
on lhs.value = rhs.key
group by lhs.key
;
EOF

psql -h matiz-materialized -p 6875 materialize > $result_file << EOF
select sum
from example_010_key_sum
where key = 'x'
;
EOF

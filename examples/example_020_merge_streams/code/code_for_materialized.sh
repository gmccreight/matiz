#!/bin/bash

scratch_dir=$1

stream_1_file=$scratch_dir/stream_1_file
stream_2_file=$scratch_dir/stream_2_file
stream_3_file=$scratch_dir/stream_3_file

touch $stream_1_file
touch $stream_2_file
touch $stream_3_file

sleep 5

cat << EOF > $scratch_dir/stream_1_generator.sh
for i in \`seq 1 500\`; do
  grouping_code=\$((\$i / 10))
  echo data: {\"id\":\$i, \"grouping_code\": \"0000\$grouping_code\", \"code\": \"\$i\"} >> $stream_1_file
  sleep 0.01
done
EOF

chmod 755 $scratch_dir/stream_1_generator.sh

cat << EOF > $scratch_dir/stream_2_generator.sh
for i in \`seq 1 500\`; do
  echo data: {\"id\":\$i, \"extra_info\": \"s2 info for \$i\"} >> $stream_2_file
  sleep 0.01
done
EOF

chmod 755 $scratch_dir/stream_2_generator.sh

cat << EOF > $scratch_dir/stream_3_generator.sh
for i in \`seq 1 500\`; do
  echo data: {\"id\":\$i, \"extra_info\": \"s3 info for \$i\"} >> $stream_3_file
  sleep 0.01
done
EOF

chmod 755 $scratch_dir/stream_3_generator.sh

$scratch_dir/stream_1_generator.sh &
sleep 1
$scratch_dir/stream_2_generator.sh &
sleep 1
$scratch_dir/stream_3_generator.sh &

# Just checking the data
for i in `seq 1 10`; do
  echo
  # echo stream_1_file
  # echo $stream_1_file
  # cat $stream_1_file
  # echo stream_2_file
  # echo $stream_2_file
  # cat $stream_2_file
  echo stream_3_file
  echo $stream_3_file
  cat $stream_3_file
  echo end
  echo
  sleep 1
done

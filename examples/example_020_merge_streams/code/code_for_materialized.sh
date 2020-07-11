#!/bin/bash

scratch_dir=$1

stream_1_file=$scratch_dir/stream_1_file
stream_2_file=$scratch_dir/stream_2_file

cat << EOF > $scratch_dir/stream_1_generator.sh
for i in \`seq 1 10\`; do
  echo data: {\"id\":\$i} >> $stream_1_file
  sleep 1
done
EOF

chmod 755 $scratch_dir/stream_1_generator.sh

cat << EOF > $scratch_dir/stream_2_generator.sh
for i in \`seq 1 5\`; do
  echo data: {\"id\":\$i} >> $stream_2_file
  sleep 2
done
EOF

chmod 755 $scratch_dir/stream_2_generator.sh

$scratch_dir/stream_1_generator.sh &
$scratch_dir/stream_2_generator.sh &

# Just checking the data
for i in `seq 1 10`; do
  echo
  echo stream_1_file
  echo $stream_1_file
  cat $stream_1_file
  echo stream_2_file
  echo $stream_2_file
  cat $stream_2_file
  echo end
  echo
  sleep 1
done

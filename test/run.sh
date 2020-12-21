#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: $0 <prefetch|readahead> <pollution_memlimit_in_MB>"
  exit 1
fi

insmod /home/injae/leap/leap.ko cmd="$1"
rmmod leap

mkdir -p /cgroup/memory
mount -t cgroup -o memory memory /cgroup/memory

mkdir -p /cgroup/memory/pollution
mkdir -p /cgroup/memory/test_process

echo "$2"M > /cgroup/memory/pollution/memory.limit_in_bytes
echo 1536M > /cgroup/memory/test_process/memory.limit_in_bytes

# Run

python3 pollution.py &
poll_pid=$!
echo $poll_pid >> /cgroup/memory/pollution/tasks

python3 matmul.py &
test_pid=$!
echo $test_pid >> /cgroup/memory/test_process/tasks
wait $test_pid

insmod /home/injae/leap/leap.ko cmd="log"
dmesg | tail
rmmod leap

kill -9 $poll_pid

umount /cgroup/memory

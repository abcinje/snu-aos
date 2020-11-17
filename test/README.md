# Benchmark 

## numpy (matrix multiplication)

* setup cgroups (to limit memory usage)
'''
sudo mount -t cgroup -o memory memory /cgroup/memory

mount | grep cgroup 
memory on /cgroup/memory type cgroup (rw,relatime,blkio)


sudo mkdir /cgroup/memory/test_process 
sudo echo 1G > /cgroup/memory/test_process/memory.limit_in_bytes  
cat /cgroup/memory/test_process/memory.limit_in_bytes 

echo 65566 >> /cgroup/memory/test_process/tasks
'''

* cache miss/hit, completion time 
'''
perf stat -o ~/wswd/test/matmul_4.15_1.out -e L1-dcache-loads-misses,L1-dcache-loads,LLC-load-misses,LLC-loads,cache-misses,cache-references python3 ~/wswd/test/matmul.py
'''


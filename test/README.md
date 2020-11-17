# Benchmark 

## numpy (matrix multiplication)

* setup cgroups (to limit memory usage)
```
sudo mount -t cgroup -o memory memory /cgroup/memory

mount | grep cgroup 
memory on /cgroup/memory type cgroup (rw,relatime,blkio)

sudo mkdir /cgroup/memory/test_process 
sudo echo 1G > /cgroup/memory/test_process/memory.limit_in_bytes  
cat /cgroup/memory/test_process/memory.limit_in_bytes 

echo 65566 >> /cgroup/memory/test_process/tasks
```

* measure cache miss/hit, completion time 
```
perf stat -o file.out -e L1-dcache-loads-misses,L1-dcache-loads,LLC-load-misses,LLC-loads,cache-misses,cache-references python3 matmul.py
```
### numpy benchmark result

* linux 4.15
```
# started on Tue Nov 17 11:51:54 2020


 Performance counter stats for 'python3 /home/csl/wswd/test/matmul.py':

  2,627,147,859,761      L1-dcache-loads-misses    #   11.63% of all L1-dcache hits    (66.67%)
  22,597,408,539,563      L1-dcache-loads                                               (66.67%)
      23,041,003,629      LLC-load-misses           #   28.32% of all LL-cache hits     (66.67%)
      81,351,919,071      LLC-loads                                                     (66.67%)
      98,800,366,211      cache-misses              #   11.690 % of all cache refs      (66.67%)
     845,141,639,602      cache-references                                              (66.67%)

      1657.970283968 seconds time elapsed
```

* linux 4.4.125 with Leap
```
# started on Tue Nov 17 12:30:02 2020


 Performance counter stats for 'python3 /home/csl/wswd/test/matmul.py':

  2,515,408,059,118      L1-dcache-loads-misses    #   10.28% of all L1-dcache hits    (66.67%)
  24,463,055,632,991      L1-dcache-loads                                               (66.67%)
      26,623,226,786      LLC-load-misses           #   29.89% of all LL-cache hits     (66.66%)
      89,067,934,897      LLC-loads                                                     (66.67%)
     106,119,183,164      cache-misses              #   12.472 % of all cache refs      (66.67%)
     850,843,566,739      cache-references                                              (66.67%)

      1360.094581324 seconds time elapsed
```

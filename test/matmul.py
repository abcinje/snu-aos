import numpy as np
import time
import os
import re

pid = os.getpid()
print("pid:", pid)
# n = 10000 * 3 # 90sec, Mem 15GB
n = 10000 * 4 # 205sec, Mem 25GB
x = np.random.randn(n,n)
a = time.time(); x.dot(x); print(time.time() - a)

status = "/proc/%d/status" % (pid)
f = open(status, "r")
find_strings = ["Pid:", "VmPeak:" ]

for line in f.readlines():
    for find_string in find_strings:
        if find_string in line.split():
            if (find_string == "VmPeak:"):
                vmpeak = re.findall("\d+", line)
                print("VmPeak: %dMB" % (int(vmpeak[0]) / (1 << 10)) )


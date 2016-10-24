#!/usr/bin/env python
# The scaling governor dictates how frequency scaling works. The
# 'performance' governor will set the cpu frequency to the maximum
# allowed.

import os
import glob

def set_perf(governor):
    with open(governor, 'w') as f:
        f.write('performance')
        print governor + ' -> performance'
    return

for cpu in glob.iglob('/sys/devices/system/cpu/cpu[0-9]*'):
    governor = cpu + '/cpufreq/scaling_governor'
    if cpu.endswith("/cpu0"):
        set_perf(governor)
    else:
        onlinename = cpu + '/online'
        if os.path.isfile(onlinename):
            with open(onlinename, 'r') as f:
                if int(f.read(1)) == 0:
                    continue
                set_perf(governor)

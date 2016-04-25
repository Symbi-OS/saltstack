#!/usr/bin/env python
# The scaling governor dictates how frequency scaling works. The
# 'performance' governor will set the cpu frequency to the maximum
# allowed.

import os
import glob

for cpu in glob.iglob('/sys/devices/system/cpu/cpu[0-9]*'):
    onlinename = cpu + '/online'
    if os.path.isfile(onlinename):
        with open(onlinename, 'r') as f:
            if int(f.read(1)) == 0:
                continue
            governor = cpu + '/cpufreq/scaling_governor'
            with open(governor, 'w') as f:
                f.write('performance')
                print governor + ' -> performance'

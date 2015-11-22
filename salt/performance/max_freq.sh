#!/bin/bash
# The scaling governor dictates how frequency scaling works. The
# 'performance' governor will set the cpu frequency to the maximum
# allowed.
for governor in $(ls /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
do
    echo "performance" > $governor || exit -1
    echo "$governor -> performance"
done
exit 0

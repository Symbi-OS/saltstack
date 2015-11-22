#!/bin/bash
# C-states are different power states the processor can go into when
# idle. This may cause long latency wakeups to occur. This script
# prevents the kernel from going into a low power state altogether
# (poll-mode). Be careful, with hyperthreads this may be detrimental.
for CPU in `ls -d -v /sys/devices/system/cpu/cpu[0-9]*`; do
    for STATE in `ls -d -v $CPU/cpuidle/state[0-9]*`; do
        BASE="$(basename $STATE)"
        if [ $BASE == "state0" ]; then
            continue
        fi
        echo "1" > $STATE/disable
        echo "disabled $STATE"
    done
done

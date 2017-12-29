#!/bin/bash
set -x
# random ints between 00-FF
OCT1=$(openssl rand -hex 1) 
OCT2=$(openssl rand -hex 1) 

rm -rf /tmp/cachescratch.out
rm -rf /tmp/cachescratch.err

for i in 1 2 4 8 12;
    do
    CS=$[$i-1]
    if [ "$CS" == "0" ]; then
	CS="$[0]"
    else
	CS="0-${CS}"
    fi
    taskset -c $CS qemu-system-x86_64 -cpu host -enable-kvm -serial stdio -display none -m 4G -smp cpus=$i --netdev tap,id=vlan1,ifname=virttap,script=no,downscript=no,vhost=on,queues=2 --device virtio-net-pci,mq=on,vectors=6,netdev=vlan1,mac=02:00:00:04:$OCT1:$OCT2 -kernel /tmp/hoardthreadtest/cachescratch/Release/bm/cachescratch.elf32 -append 'niterations=1000000;repetitions=100;nthreads='$i';objSize=8;' >>/tmp/cachescratch.out 2>>/tmp/cachescratch.err;

    taskset -c $CS /tmp/hoardthreadtest/cachescratch/Release/cachescratch $i 1000000 8 100
done

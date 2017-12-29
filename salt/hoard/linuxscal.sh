#!/bin/bash
set -x
# random ints between 00-FF
OCT1=$(openssl rand -hex 1) 
OCT2=$(openssl rand -hex 1) 

rm -rf /tmp/linuxscal.out
rm -rf /tmp/linuxscal.err

for i in 1 2 4 8 12;
    do
    CS=$[$i-1]
    if [ "$CS" == "0" ]; then
	CS="$[0]"
    else
	CS="0-${CS}"
    fi
    taskset -c $CS qemu-system-x86_64 -cpu host -enable-kvm -serial stdio -display none -m 4G -smp cpus=$i --netdev tap,id=vlan1,ifname=virttap,script=no,downscript=no,vhost=on,queues=2 --device virtio-net-pci,mq=on,vectors=6,netdev=vlan1,mac=02:00:00:04:$OCT1:$OCT2 -kernel /tmp/hoardthreadtest/linux-scalability/Release/bm/linux-scalability.elf32 -append 'niterations=10000000;nthreads='$i';objSize=8;' >>/tmp/linuxscal.out 2>>/tmp/linuxscal.err;

    taskset -c $CS /tmp/hoardthreadtest/linux-scalability/Release/linux-scalability 8 10000000 $i
done

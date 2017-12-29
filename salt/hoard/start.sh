#!/bin/bash
set -x
# random ints between 00-FF
OCT1=$(openssl rand -hex 1) 
OCT2=$(openssl rand -hex 1) 

rm -rf /tmp/stdout
rm -rf /tmp/stderr

for j in `seq 1 50`;
do
    for i in 12;
    do
	CS=$[$i-1]
	if [ "$CS" == "0" ]; then
	    CS="$[0]"
	else
	    CS="0-${CS}"
	fi
	#taskset -c $CS qemu-system-x86_64 -cpu host -enable-kvm -serial stdio -display none -m 4G -smp cpus=$i --netdev tap,id=vlan1,ifname=virttap,script=no,downscript=no,vhost=on,queues=2 --device virtio-net-pci,mq=on,vectors=6,netdev=vlan1,mac=02:00:00:04:$OCT1:$OCT2 -kernel /tmp/hoardthreadtest/Release/bm/hoardthreadtest.elf32 -append 'niterations=1000000;nobjects=100;nthreads='$i';work=0;objSize=1;' >>/tmp/stdout;
	#taskset -c $CS /tmp/hoardthreadtest/Release/hoardthreadtest $i 1000000 100 0 1 >>/tmp/stdout;
	export LD_PRELOAD=/tmp/jemalloc-4.2.1/build/lib/libjemalloc.so
	taskset -c $CS /tmp/hoardthreadtest/Release/hoardthreadtest $i 1000000 100 0 1 >>/tmp/stdout;
    done
done

#for i in 1 2 4 8 12;
#    do
#    CS=$[$i-1]
#    if [ "$CS" == "0" ]; then
#	CS="$[0]"
#    else
#	CS="0-${CS}"
#    fi
#
#    taskset -c $CS /tmp/hoardthreadtest/Release/hoardthreadtest $i 1000 100000 0 1
#
#done

#for i in 1 2 4 8 12;
#   do
#    CS=$[$i-1]
#    if [ "$CS" == "0" ]; then
#	CS="$[0]"
#    else
#	CS="0-${CS}"
#    fi
#
#    export LD_PRELOAD=/tmp/jemalloc-4.2.1/build/lib/libjemalloc.so
#    taskset -c $CS /tmp/hoardthreadtest/Release/hoardthreadtest $i 1000 100000 0 1
#
#done

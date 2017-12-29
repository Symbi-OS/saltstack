#!/bin/bash
set -x
# random ints between 00-FF
OCT1=$(openssl rand -hex 1) 
OCT2=$(openssl rand -hex 1) 

rm -rf /tmp/stdout
rm -rf /tmp/stderr

for i in 1 2 4 8 12;
    do
    CS=$[$i-1]
    if [ "$CS" == "0" ]; then
	CS="$[0]"
    else
	CS="0-${CS}"
    fi

    taskset -c $CS qemu-system-x86_64 -cpu host -enable-kvm -serial stdio -display none -m 4G -smp cpus=$i --netdev tap,id=vlan1,ifname=virttap,script=no,downscript=no,vhost=on,queues=2 --device virtio-net-pci,mq=on,vectors=6,netdev=vlan1,mac=02:00:00:04:$OCT1:$OCT2 -kernel /tmp/EbbRT/apps/danalloctest/danalloctest.elf32 >>/tmp/stdout 2>>/tmp/stderr;

done

for i in 1 2 4 8 12;
    do
    CS=$[$i-1]
    if [ "$CS" == "0" ]; then
	CS="$[0]"
    else
	CS="0-${CS}"
    fi

    #taskset -c $CS /tmp/EbbRT/apps/danalloctest/danalloctest_glibc $i
    /tmp/EbbRT/apps/danalloctest/danalloctest_glibc $i
    echo

done

for i in 1 2 4 8 12;
    do
    CS=$[$i-1]
    if [ "$CS" == "0" ]; then
	CS="$[0]"
    else
	CS="0-${CS}"
    fi

    #taskset -c $CS LD_PRELOAD=/tmp/jemalloc/build/lib/libjemalloc.so.2 /tmp/EbbRT/apps/danalloctest/danalloctest_glibc $i
    LD_PRELOAD=/tmp/jemalloc/build/lib/libjemalloc.so.2 /tmp/EbbRT/apps/danalloctest/danalloctest_glibc $i
    echo

done

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
    #taskset -c $CS qemu-system-x86_64 -cpu host -enable-kvm -serial stdio -display none -m 4G -smp cpus=$i --netdev tap,id=vlan1,ifname=virttap,script=no,downscript=no,vhost=on,queues=2 --device virtio-net-pci,mq=on,vectors=6,netdev=vlan1,mac=02:00:00:04:$OCT1:$OCT2 -kernel /tmp/hoardthreadtest/alloctest/Release/bm/alloctest.elf32 -append 'niterations=10;nobjects='$i';nthreads='$i';work=0;objSize=1;' >>/tmp/stdout 2>>/tmp/stderr;
    taskset -c $CS qemu-system-x86_64 -cpu host -enable-kvm -serial stdio -display none -m 4G -smp cpus=$i --netdev tap,id=vlan1,ifname=virttap,script=no,downscript=no,vhost=on,queues=2 --device virtio-net-pci,mq=on,vectors=6,netdev=vlan1,mac=02:00:00:04:$OCT1:$OCT2 -kernel /tmp/hoardthreadtest/danalloctest/Release/bm/danalloctest.elf32 >>/tmp/stdout 2>>/tmp/stderr;

    #taskset -c $CS /tmp/hoardthreadtest/alloctest/Release/alloctest $i 10 100 0 1
    taskset -c $CS /tmp/hoardthreadtest/danalloctest/Release/danalloctest_glibc $i
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

    taskset -c $CS /tmp/hoardthreadtest/danalloctest/Release/danalloctest_jemalloc $i
    echo
done

#!/bin/bash

( qemu-system-x86_64 \
-cpu host -enable-kvm -serial stdio -display none \
-m 4G -smp cpus=4 \
--netdev \
tap,id=vlan1,ifname=virttap,script=no,downscript=no,vhost=on,queues=4 \
--device \
virtio-net-pci,mq=on,vectors=10,netdev=vlan1,mac=02:00:00:04:00:29 \
-pidfile /tmp/pid \
-kernel /tmp/ebbrt-memcached/baremetal/build/Release/mcd.elf32 \
>/tmp/stdout \
2>/tmp/stderr; date >/tmp/finish;)&

#while [ -z "$pids" ]
#do
#  pids=$( pgrep vhost- )
#done
#
## pin vhosts to cpu 2,4,6,8
#core=2
#for pid in $pids
#do
#    taskset -pc $core $pid
#    core=$(( $core + 2 ))
#done

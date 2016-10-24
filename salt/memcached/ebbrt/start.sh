#!/bin/bash
set -x
# random ints between 00-FF
OCT1=$(openssl rand -hex 1) 
OCT2=$(openssl rand -hex 1) 

{% set cpus                = salt['pillar.get']('memcached:cpus','1')%}
{% set mq_queues           = salt['pillar.get']('memcached:mq_queues','2')%}
{% set mq_vectors          = salt['pillar.get']('memcached:mq_vectors','6')%}
{% set ram_qb              = salt['pillar.get']('memcached:ram_qb','4')%}
{% set core_pin            = salt['pillar.get']('memcached:core_pin','4096')%}
{% set vhost_pin_start     = salt['pillar.get']('memcached:vhost_pin_start','0')%}
{% set vhost_pin_inc       = salt['pillar.get']('memcached:vhost_pin_inc','1')%}

( taskset -c {{ core_pin }} qemu-system-x86_64 \
-cpu host -enable-kvm -serial stdio -display none \
-m 4G -smp cpus={{ cpus }} \
--netdev \
tap,id=vlan1,ifname=virttap,script=no,downscript=no,vhost=on,queues={{ mq_queues }} \
--device virtio-net-pci,mq=on,vectors={{ mq_vectors }},\
netdev=vlan1,mac=02:00:00:04:$OCT1:$OCT2 \
-pidfile /tmp/pid \
-kernel /tmp/ebbrt-memcached/baremetal/build/Release/mcd.elf32 \
>/tmp/stdout \
2>/tmp/stderr; date >/tmp/finish; )&

while [ -z "$pids" ]
do
  sleep 2
  pids=$( pgrep vhost- )
done
core={{ vhost_pin_start }}
for pid in $pids
do
    taskset -pc $core $pid
    core=$(( $core + {{ vhost_pin_inc }} ))
done

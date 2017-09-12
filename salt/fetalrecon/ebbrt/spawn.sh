#!/bin/bash
set -x

# pull port and hostid from commandline
HOSTADDR=${1:-0}
HOSTPORT=${2:-0}
ALLOCID=${3:-0}

# random ints between 00-FF
OCT1=$(openssl rand -hex 1) 
OCT2=$(openssl rand -hex 1) 

{% set cpus                = salt['pillar.get']('qemu:cpus','6')%}
{% set mq_queues           = salt['pillar.get']('qemu:mq_queues','6')%}
{% set mq_vectors          = salt['pillar.get']('qemu:mq_vectors','14')%}
{% set ram_qb              = salt['pillar.get']('qemu:ram_qb','4')%}
{% set core_pin            = salt['pillar.get']('qemu:core_pin','0-5')%}
{% set vhost_pin_start     = salt['pillar.get']('qemu:vhost_pin_start','6')%}
{% set vhost_pin_inc       = salt['pillar.get']('qemu:vhost_pin_inc','1')%}

( taskset -c {{ core_pin }} qemu-system-x86_64 \
-cpu host -enable-kvm -serial stdio -display none \
-m 4G -smp cpus={{ cpus }} \
--netdev \
tap,id=vlan1,ifname=virttap,script=no,downscript=no,vhost=on,queues={{ mq_queues }} \
--device virtio-net-pci,mq=on,vectors={{ mq_vectors }},\
netdev=vlan1,mac=02:00:00:04:$OCT1:$OCT2 \
-pidfile /root/pid \
-kernel /root/spawn.elf32 \
-append "host_addr=$HOSTADDR;host_port=$HOSTPORT;allocid=$ALLOCID" \
>/root/stdout \
2>/root/stderr; date >/root/finish; )&

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

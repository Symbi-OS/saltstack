#!/bin/bash
set -x
# random ints between 00-FF
OCT1=$(openssl rand -hex 1) 
OCT2=$(openssl rand -hex 1) 
KERNEL=/tmp/osv_mcd.img
VMID=$OCT1$OCT2
TAP=virttap_$VMID

ip tuntap add dev $TAP mode tap || exit -1
ip link set $TAP master virtbr | exit -1
ip link set $TAP up | exit -1

{% set cpus                = salt['pillar.get']('memcached:cpus','1')%}
{% set mq_queues           = salt['pillar.get']('memcached:mq_queues','2')%}
{% set mq_vectors          = salt['pillar.get']('memcached:mq_vectors','6')%}
{% set ram_qb              = salt['pillar.get']('memcached:ram_qb','4')%}
{% set core_pin            = salt['pillar.get']('memcached:core_pin','4096')%}
{% set vhost_pin_start     = salt['pillar.get']('memcached:vhost_pin_start','0')%}
{% set vhost_pin_inc       = salt['pillar.get']('memcached:vhost_pin_inc','1')%}

( taskset -c {{ core_pin }} qemu-system-x86_64 \
-cpu host,+x2apic -enable-kvm -display none \
-m {{ ram_qb }}G -smp cpus={{ cpus }} \
--netdev \
tap,id=vlan1,ifname=$TAP,script=no,downscript=no,vhost=on \
-device virtio-net-pci,netdev=vlan1,mac=02:00:00:04:$OCT1:$OCT2 \
-device virtio-blk-pci,id=blk0,bootindex=0,drive=hd0,scsi=off \
-drive file=$KERNEL,if=none,id=hd0,aio=threads,cache=unsafe \
-device virtio-rng-pci -chardev stdio,mux=on,id=stdio,signal=off \
-mon chardev=stdio,mode=readline,default -device isa-serial,chardev=stdio \
-pidfile /tmp/pid \
>/tmp/stdout \
2>/tmp/stderr; date >/tmp/finish; )&

while [ -z "$pids" ]
do
  pids=$( pgrep vhost- )
done
core={{ vhost_pin_start }}
for pid in $pids
do
    taskset -pc $core $pid
    core=$(( $core + {{ vhost_pin_inc }} ))
done

### LATEST RUN 
# DIFF: aio=native, host+x2apic
#qemu-system-x86_64 -m 2G -smp 4 -vnc :1 -gdb tcp::1234,server,nowait -device
#virtio-blk-pci,id=blk0,bootindex=0,drive=hd0,scsi=off -drive
#file=/root/osv/build/last/usr.img,if=none,id=hd0,cache=unsafe,aio=threads
#-netdev tap,id=hn0,script=scripts/qemu-ifup.sh,vhost=on -device
#virtio-net-pci,netdev=hn0,id=nic0 -redir tcp:2222::22 -device virtio-rng-pci
#-enable-kvm -cpu host,+x2apic -chardev stdio,mux=on,id=stdio,signal=off -mon
#chardev=stdio,mode=readline,default -device isa-serial,chardev=stdio#

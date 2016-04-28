#!/bin/bash

# random ints between 00-FF
OCT1=$(openssl rand -hex 1) 
OCT2=$(openssl rand -hex 1) 
VMID=$OCT1$OCT2
TAP=virttap_$VMID

ip tuntap add dev $TAP mode tap multi_queue || exit -1
ip link set $TAP master virtbr | exit -1
ip link set $TAP up | exit -1

touch /tmp/pid_$VMID
# Note: 4 core, no pinning
qemu-system-x86_64 -daemonize -cpu host -enable-kvm -m 4G -smp cpus=4 \
--netdev  tap,id=vlan1,ifname=$TAP,script=no,downscript=no,vhost=on,queues=4 \
-boot n -display none --device \
virtio-net-pci,mq=on,vectors=10,netdev=vlan1,mac=02:00:00:04:$OCT1:$OCT2 \

exit 0

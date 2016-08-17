#!/usr/bin/env python

import random
import subprocess

{% set cpus                = salt['pillar.get']('nodejs:cpus','1')%}
{% set mq_queues           = salt['pillar.get']('nodejs:mq_queues','2')%}
{% set mq_vectors          = salt['pillar.get']('nodejs:mq_vectors','6')%}
{% set ram_qb              = salt['pillar.get']('nodejs:ram_qb','4')%}
{% set core_pin            = salt['pillar.get']('nodejs:core_pin','6')%}
{% set vhost_pin_start     = salt['pillar.get']('nodejs:vhost_pin_start','0')%}
{% set vhost_pin_inc       = salt['pillar.get']('nodejs:vhost_pin_inc','1')%}

# random ints between 00-FF
OCT1=hex(random.randint(0,255))[2:].upper()
OCT2=hex(random.randint(0,255))[2:].upper()

p = subprocess.Popen("taskset -c {{ core_pin }} qemu-system-x86_64 -cpu host " +
                     "-enable-kvm -nographic -m 4G -smp cpus={{ cpus }} " +
                     "--netdev tap,id=vlan1,ifname=virttap,script=no," +
                     "downscript=no,vhost=on,queues={{ mq_queues }} " +
                     "--device virtio-net-pci,mq=on,vectors={{ mq_vectors }}," +
                     "netdev=vlan1,mac=02:00:00:04:" + OCT1 + ":" + OCT2 +
                     " -kernel /tmp/ebbrt-node/build/bm/node.elf32", shell=True)

while True:
    try:
        out = subprocess.check_output(['pgrep', 'vhost-'])
        break
    except subprocess.CalledProcessError:
        continue

pids = out.splitlines()
core = {{ vhost_pin_start }}
for pid in pids:
    subprocess.call(['taskset', '-pc', str(core), str(pid)])
    core += {{vhost_pin_inc}}

p.wait()

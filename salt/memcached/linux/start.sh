#!/bin/bash
set -x

IP=$(/tmp/mcd_server_ip.sh)

{% set cpus                = salt['pillar.get']('memcached:cpus','1')%}
{% set ram_mb              = salt['pillar.get']('memcached:ram_mb','1024')%}
{% set core_pin            = salt['pillar.get']('memcached:core_pin','8')%}
{% set port                = salt['pillar.get']('memcached:port',11211)%}

taskset -c {{ core_pin }} \
/tmp/memcached/memcached -u nobody -d -p {{ port }} -t {{ cpus }} -m {{ ram_mb }} -l $IP

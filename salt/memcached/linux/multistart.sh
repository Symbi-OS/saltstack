#!/bin/bash
set -x

IP=$(/tmp/mcd_server_ip.sh)

{% set cpus                = salt['pillar.get']('memcached:cpus','1')%}
{% set ram_mb              = salt['pillar.get']('memcached:ram_mb','1024')%}
{% set core_pin            = salt['pillar.get']('memcached:core_pin','0')%}
{% set port                = salt['pillar.get']('memcached:port',11211)%}


core=0
port={{ port }}
cpus={{ cpus }}


while [ $core -lt $cpus ]; do
  taskset -c $core \
  /tmp/memcached/memcached -U 0 -u nobody -d -p $port -t 1 -m {{ ram_mb }} -l $IP
  core=$(( $core + 1 ))
  port=$(( $port + 1 ))
done

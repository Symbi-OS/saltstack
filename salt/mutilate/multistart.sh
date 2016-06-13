#!/bin/bash
# Starts local mutilate process
set -x

MUTILATE=/tmp/mutilate/mutilate
{% set role  = salt['grains.get']('role', 'minion') %}
{% set cores = salt['grains.get']('num_cpus', '1') %}

# mutilate master 
{% if role == 'master' %}
{% set K_val = salt['pillar.get']('mutilate:K_val','30')%}
{% set V_val = salt['pillar.get']('mutilate:V_val','200')%}
{% set i_val = salt['pillar.get']('mutilate:i_val','exponential')%}
{% set u_val = salt['pillar.get']('mutilate:u_val','0')%}
{% set c_val = salt['pillar.get']('mutilate:c_val','8')%}
{% set d_val = salt['pillar.get']('mutilate:d_val','4')%}
{% set C_val = salt['pillar.get']('mutilate:C_val','8')%}
{% set Q_val = salt['pillar.get']('mutilate:Q_val','1000')%}
{% set t_val = salt['pillar.get']('mutilate:t_val','30')%}
{% set scan_val = salt['pillar.get']('mutilate:scan_val','50000:600000:50000')%}
{% set mcd_ip = salt['mine.get']('role:server', 'mcd_server_ip', expr_form='grain').items() %}

{% set cpus                = salt['pillar.get']('memcached:cpus','1')%}
{% set port                = salt['pillar.get']('memcached:port',11211)%}


core=0
port={{ port }}
cpus={{ cpus }}

SERVERS=""
while [ $core -lt $cpus ]; do
  SERVERS="$SERVERS -s {{ mcd_ip[0][1] }}:$port"
  core=$(( $core + 1 ))
  port=$(( $port + 1 ))
done

      # set pinning ranges
      {% if cores > 1 %}
        {% set core = cores - 1 %}
      {% endif %}
      taskset -c 1-{{ core }} $MUTILATE -A --affinity -T {{ core }} > \
        stdout.agent.log 2>&1 &
      taskset -c 0 $MUTILATE --binary --loadonly \
        $SERVERS \
        -K {{ K_val }} -V {{ V_val }}
      taskset -c 0 $MUTILATE --binary --noload -B \
        $SERVERS \
        -a localhost \
      {% for minion, addrs in salt['mine.get']('role:minion', 'network.interfaces', expr_form='grain').items() %} \
        -a {{ minion }} \
      {% endfor %} \
      -K {{ K_val }} -V {{ V_val }} -i {{ i_val }} -u {{ u_val }} \
      -c 1 -d {{ d_val }} -C {{ C_val }} -Q {{ Q_val }} \
      -t {{ t_val }} --scan={{ scan_val }} > >(tee stdout.mutilate.log) \
      2> >(tee stderr.mutilate.log >&2)
# mutilate agents
{% else %}
  $MUTILATE -A --affinity -T {{ cores }} > stdout.agent.log 2>&1 &
{% endif %}

{% set kv_port = salt['pillar.get']('docker:kv:port','8500')%}
{% set swarm_port = salt['pillar.get']('docker:swarm:port','4000')%}
{% set d_port = salt['pillar.get']('docker:port','2375')%}

{% set host = salt['grains.get']('id')%}
{% set kv_host = salt['pillar.get']('docker:kv:host')%}

{% set kv_type = salt['pillar.get']('docker:kv:type')%}

start_manager:
  cmd.run:
    - name: |
        docker run -d --net weave -p {{ swarm_port }}:{{ d_port }} swarm manage {{ kv_type }}://{{ kv_host }}:{{ kv_port }}

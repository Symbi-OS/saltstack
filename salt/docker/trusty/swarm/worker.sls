{% set kv_port = salt['pillar.get']('docker:kv:port','8500')%}
{% set d_port = salt['pillar.get']('docker:port','2375')%}

{% set host = salt['grains.get']('id')%}
{% set kv_host = salt['pillar.get']('docker:kv:host')%}

{% set kv_type = salt['pillar.get']('docker:kv:type')%}

start_worker:
  cmd.run:
    - name: |
        docker run -d --net weave swarm join --advertise={{ host }}:{{ d_port }} {{ kv_type }}://{{ kv_host }}:{{ kv_port }}

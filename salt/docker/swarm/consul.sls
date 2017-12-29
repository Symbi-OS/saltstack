{% set kv_port = salt['pillar.get']('docker:kv:port','8500')%}

start_consul:
  cmd.run:
    - name: |
        docker run -d --net weave -p {{ kv_port }}:{{ kv_port }} --hostname consul progrium/consul -server -bootstrap

{% set kv_host = salt['pillar.get']('docker:kv:host')%}
include:
  - docker 

install_weave:
  cmd.run:
    - name: |
        export CHECKPOINT_DISABLE=1
        wget -O /usr/local/bin/weave https://github.com/weaveworks/weave/releases/download/latest_release/weave || exit -1
        chmod a+x /usr/local/bin/weave || exit -1

launch_weave:
  cmd.run:
    - name: |
        ip link set eth2 mtu 8916
        export EBBRT_NODE_ALLOCATOR_DEFAULT_NETWORK_ARGUMENTS=weave
        WEAVE_MTU=8916 weave launch
        weave connect {{ kv_host }} 
        weave expose
    - require:
      - sls: docker
      - cmd: install_weave


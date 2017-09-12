{% set kv_host = salt['pillar.get']('docker:kv:host')%}

include:
  - docker

install_weave:
  cmd.run:
    - name: |
        export CHECKPOINT_DISABLE=1
        wget -O /usr/local/bin/weave https://github.com/weaveworks/weave/releases/download/latest_release/weave || exit -1
        chmod a+x /usr/local/bin/weave || exit -1
    - require:
      - sls: docker

launch_weave:
  cmd.run:
    - name: |
        weave launch
        WEAVE_MTU=1500 weave connect {{ kv_host }} 
        weave expose
    - require:
      - cmd: install_weave


install_weave:
  cmd.run:
    - name: |
        export CHECKPOINT_DISABLE=1
        curl -L git.io/weave -o /usr/local/bin/weave || exit -1
        chmod a+x /usr/local/bin/weave || exit -1

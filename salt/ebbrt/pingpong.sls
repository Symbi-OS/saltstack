https://github.com/dschatzberg/EbbRT-PingPong.git:
  git.latest:
    - target: /tmp/ebbrt-pingpong
    - user: root

ebbrt-pingpong-built:
  cmd.run:
    - cwd: /tmp/ebbrt-pingpong
    - name: |
        make -j {{salt['grains.get']('num_cpus', 'a')}} || exit -1
    - env:
      - EBBRT_SRCDIR: '/tmp/ebbrt'
    - timeout: 300
    - unless: test -x /tmp/ebbrt-pingpong/hosted/build/Release/pingpong

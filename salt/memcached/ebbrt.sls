include:
  - ebbrt

https://github.com/sesa/ebbrt-memcached.git:
  git.latest:
    - target: /tmp/ebbrt-memcached
    - user: root

ebbrt-memcached-built:
  cmd.run:
    - cwd: /tmp/ebbrt-memcached
    - name: |
        make -j {{salt['grains.get']('num_cpus', '1')}} || exit -1
    - env:
      - EBBRT_SRCDIR: '/tmp/ebbrt'
    - timeout: 300
    - unless: test -x /tmp/ebbrt-memcached/baremetal/build/Release/mcd.elf32
    - require:
        - sls: ebbrt
        - git: https://github.com/sesa/ebbrt-memcached.git
          

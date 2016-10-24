include:
  - ebbrt
  - qemu.tap

/tmp/mcd_server_ip.sh:
  file.managed:
  - source: salt://memcached/ebbrt/server_ip.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755

https://github.com/sesa/ebbrt-memcached.git:
  git.latest:
    - rev: 4965b6b9d80001557ad086c1cab17ec3aef8496c 
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

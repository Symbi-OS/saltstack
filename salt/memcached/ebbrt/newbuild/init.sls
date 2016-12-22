include:
  - ebbrt.newbuild.deps-only
  - qemu.tap

toolchain:
  cmd.run:
    - cwd: /tmp/ebbrt/toolchain
    - name: |
        make -j CMAKE_OPT='-DCMAKE_BUILD_TYPE=Release \
        -D__EBBRT_ENABLE_DISTRIBUTED_RUNTIME__=OFF \
        -DVIRTIO_NET_POLL=ON' || exit -1
    - timeout: 800
    - unless: test -x /tmp/ebbrt/toolchain/sysroot/usr/bin/x86_64-pc-ebbrt-g++
    - require:
      - sls: ebbrt.newbuild.deps-only 

/tmp/mcd_server_ip.sh:
  file.managed:
  - source: salt://memcached/ebbrt/server_ip.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755

https://github.com/sesa/ebbrt-memcached.git:
  git.latest:
    - target: /tmp/ebbrt-memcached
    - user: root

ebbrt-memcached-built:
  cmd.run:
    - cwd: /tmp/ebbrt-memcached
    - name: |
        cmake -DCMAKE_TOOLCHAIN_FILE=/tmp/ebbrt/src/cmake/ebbrt.cmake \
        -DCMAKE_BUILD_TYPE=Release . || exit -1
        make -j {{salt['grains.get']('num_cpus', '1')}} || exit -1
    - env:
      - EBBRT_SYSROOT: '/tmp/ebbrt/toolchain/sysroot'
    - unless: test -x /tmp/ebbrt-memcached/memcached.elf32
    - timeout: 300
    - require:
      - cmd: toolchain

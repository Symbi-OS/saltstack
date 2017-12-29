include:
  - ebbrt.newbuild.deps-only
  - qemu.tap

toolchain:
  cmd.run:
    - cwd: /tmp/ebbrt/toolchain
    - name: |
        make -j CMAKE_OPT='-DCMAKE_BUILD_TYPE=Release \
        -D__EBBRT_ENABLE_DISTRIBUTED_RUNTIME__=OFF \
        -DVIRTIO_ZERO_COPY=ON \
        -DLARGE_WINDOW_HACK=ON \
        -DVIRTIO_NET_POLL=ON' || exit -1
    - timeout: 800
    - unless: test -x /tmp/ebbrt/toolchain/sysroot/usr/bin/x86_64-pc-ebbrt-g++
    - require:
      - sls: ebbrt.newbuild.deps-only 

https://github.com/jmcadden/ebbrt-contrib.git:
  git.latest:
    - target: /tmp/contrib
    - user: root

ebbrt-netpip-built:
  cmd.run:
    - cwd: /tmp/contrib/apps/netpipek
    - name: |
        cmake -DCMAKE_TOOLCHAIN_FILE=/tmp/ebbrt/toolchain/sysroot/usr/misc/ebbrt.cmake \
        -DCMAKE_BUILD_TYPE=Release . || exit -1
        make -j {{salt['grains.get']('num_cpus', '1')}} || exit -1
    - env:
      - EBBRT_SRCDIR: '/tmp/ebbrt'
      - EBBRT_SYSROOT: '/tmp/ebbrt/toolchain/sysroot'
    - unless: test -x /tmp/contrib/apps/netpipek/netpipek.elf32
    - timeout: 300
    - require:
      - git: https://github.com/jmcadden/ebbrt-contrib.git
      - cmd: toolchain

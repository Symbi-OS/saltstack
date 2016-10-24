include:
  - ebbrt.newbuild.deps-only
  - qemu.tap

toolchain:
  cmd.run:
    - cwd: /tmp/ebbrt/toolchain
    - name: |
        make -j {{salt['grains.get']('num_cpus', '1')}} \
        CMAKE_OPT='-DCMAKE_BUILD_TYPE=Release \
        -D__EBBRT_ENABLE_DISTRIBUTED_RUNTIME__=OFF' || exit -1
    - timeout: 800
    - unless: test -x /tmp/ebbrt/toolchain/sysroot/usr/bin/x86_64-pc-ebbrt-g++
    - require:
      - sls: ebbrt.newbuild.deps-only 

filesystem:
  cmd.run:
    - cwd: /tmp/ebbrt/libs/filesystem
    - name: |
        cmake -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_TOOLCHAIN_FILE=/tmp/ebbrt/toolchain/sysroot/usr/misc/ebbrt.cmake \
        && make -j {{salt['grains.get']('num_cpus', '1')}} install || exit -1
    - env:
      - EBBRT_SYSROOT: '/tmp/ebbrt/toolchain/sysroot'
    - unless: test -x /tmp/ebbrt/toolchain/sysroot/usr/lib/libebbrt-filesystem.a
    - timeout: 600
    - require:
      - cmd: toolchain

https://github.com/sesa/ebbrt-node-app.git:
  git.latest:
    - submodules: True
    - target: /tmp/ebbrt-node
    - user: root

ebbrt-node-built:
  cmd.run:
    - cwd: /tmp/ebbrt-node
    - name: |
        make -j {{salt['grains.get']('num_cpus', '1')}} native || exit -1
    - env:
      - NODE_CONFIG_FLAGS: '--ebbrt-script=hello_http'
      - EBBRT_SYSROOT: '/tmp/ebbrt/toolchain/sysroot'
    - unless: test -x /tmp/ebbrt-node/build/bm/node.elf32
    - timeout: 300
    - require:
      - cmd: toolchain
      - cmd: filesystem

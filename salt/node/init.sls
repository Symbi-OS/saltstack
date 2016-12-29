include:
  - ebbrt
  - ebbrt.libs.cmdline
  - ebbrt.libs.filesystem


node-install:
  cmd.run:
    - cwd: /tmp/ebbrt/apps/node
    - name: |
        EBBRT_SYSROOT=/tmp/ebbrt/toolchain/sysroot CMAKE_PREFIX_PATH=/tmp/ebbrt/install make -j all || exit -1
    - require:
      - sls: ebbrt
      - sls: ebbrt.libs.cmdline
      - sls: ebbrt.libs.filesystem

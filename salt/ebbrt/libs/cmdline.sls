include:
  - ebbrt.init

cmdline-hosted:
  cmd.run:
    - env:
      - CMAKE_BUILD_TYPE: 'Release'
      - CMAKE_PREFIX_PATH: '/tmp/ebbrt/hosted/install'
      - CMAKE_INSTALL_PREFIX: '/tmp/ebbrt/hosted/install'
    - cwd: /tmp/ebbrt/libs/cmdline
    - name: |
        mkdir buildh || exit -1
        cd buildh
        cmake ..  || exit -1
        make -j install || exit -1
    - timeout: 300
   
cmdline-native:
  cmd.run:
    - env:
      - EBBRT_SYSROOT: '/tmp/ebbrt/toolchain/sysroot'
      - CMAKE_TOOLCHAIN_FILE: '/tmp/ebbrt/toolchain/sysroot/usr/misc/ebbrt.cmake'
      - CMAKE_PREFIX_PATH: '/tmp/ebbrt/toolchain/sysroot'
    - cwd: /tmp/ebbrt/libs/cmdline
    - name: |
        mkdir buildn || exit -1
        cd buildn
        cmake ..  || exit -1
        make -j install || exit -1
    - timeout: 300

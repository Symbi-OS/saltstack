include:
  - ebbrt

filesystem-hosted:
  cmd.run:
    - cwd: /tmp/ebbrt/libs/filesystem
    - name: |
        mkdir -p buildh || exit -1
        cd buildh
        cmake -DCMAKE_INSTALL_PREFIX=/tmp/ebbrt/install -DCMAKE_PREFIX_PATH=/tmp/ebbrt/install ..  || exit -1
        make -j install || exit -1
    - timeout: 300
   
filesystem-native:
  cmd.run:
    - env:
      - EBBRT_SYSROOT: '/tmp/ebbrt/toolchain/sysroot'
    - cwd: /tmp/ebbrt/libs/filesystem
    - name: |
        mkdir -p buildn || exit -1
        cd buildn
        cmake -DCMAKE_INSTALL_PREFIX=/tmp/ebbrt/toolchain/sysroot/ -DCMAKE_TOOLCHAIN_FILE=/tmp/ebbrt/toolchain/sysroot/usr/misc/ebbrt.cmake -DCMAKE_PREFIX_PATH=/tmp/ebbrt/toolchain/sysroot ..  || exit -1
        make -j install || exit -1
    - timeout: 300

include:
  - docker
  - qemu

ebbrt-build-depends:
  pkg.installed:
    - refresh: true
    - timeout: 300
    - pkgs:
       - automake
       - build-essential
       - git
       - libtool 
       - cmake 
       - libboost-dev
       - libboost-filesystem-dev 
       - libboost-coroutine-dev 
       - libtbb-dev
       - texinfo

extract-capnproto-tarball:
  archive.extracted:
    - name: /tmp/capnproto
    - source: https://github.com/sandstorm-io/capnproto/archive/v0.4.0.tar.gz
    - source_hash: md5=30e7f69d2ca532be7089127fa8e8eb01
    - archive_format: tar
    - tar_options: z
    - unless: test -d /tmp/capnproto

install-capnproto:
  cmd.run:
    - cwd: /tmp/capnproto/capnproto-0.4.0/c++
    - name: |
        autoreconf -i || exit -1
        CXXFLAGS="-O2 -DNDEBUG -fpermissive" ./configure || exit -1
        make -j {{salt['grains.get']('num_cpus', '1')}} || exit -1
        make install
    - timeout: 300
    - unless: test -x /usr/local/bin/capnp
    - require:
        - archive: extract-capnproto-tarball
        - pkg: ebbrt-build-depends 
        
https://github.com/sesa/ebbrt.git:
  git.latest:
    - target: /tmp/ebbrt
    - user: root
    - submodules: true
    - require:
        - pkg: ebbrt-build-depends 

ebbrt-toolchain-fetched:
  cmd.run:
    - cwd: /tmp/ebbrt/toolchain
    - name: |
        make -j CMAKE_OPT='-DCMAKE_BUILD_TYPE=Release \
        -D__EBBRT_ENABLE_DISTRIBUTED_RUNTIME__=OFF \
        -D__EBBRT_ENABLE_NETWORKING__=OFF' || exit -1
    - timeout: 800
    - unless: test -x /tmp/ebbrt/toolchain/sysroot/usr/bin/x86_64-pc-ebbrt-g++
    - require:
      - git: https://github.com/sesa/ebbrt.git

ebbrt-hosted:
  cmd.run:
    - cwd: /tmp/ebbrt/hosted
    - name: |
        cmake . || exit -1
        make -j install || exit -1
    - env:
      - EBBRT_SRCDIR: '/tmp/ebbrt'
      - EBBRT_SYSROOT: '/tmp/ebbrt/toolchain/sysroot'
    - timeout: 300
    - unless: test -a /tmp/ebbrt/hosted/usr/lib/libEbbRT.a
    - require:
      - cmd: ebbrt-toolchain-fetched
      - git: https://github.com/sesa/ebbrt.git

pull-docker-files:
  cmd.run:
    - name: |
        docker pull ebbrt/kvm-qemu:latest || exit -1
        docker pull ebbrt/kvm-qemu:debug || exit -1
    - require:
      - sls: docker

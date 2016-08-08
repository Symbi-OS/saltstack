include:
  - docker
  - qemu
  - ebbrt.env

ebbrt-build-depends:
  pkg.installed:
    - refresh: true
    - timeout: 300
    - pkgs:
       - automake
       - build-essential
       - git
       - libtool 
       - libfdt-dev
       - cmake 
       - libboost-dev
       - libboost-filesystem-dev 
       - libboost-coroutine-dev 
       - libtbb-dev

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
    - rev: 77384cc41d916f445a33df5a92871872c74dcc20
    - target: /tmp/ebbrt
    - user: root
    - submodules: true
    - require:
        - pkg: ebbrt-build-depends 

ebbrt-toolchain-fetched:
  cmd.run:
    - cwd: /tmp/ebbrt/baremetal/ext/EbbRT-toolchain
    - name: |
        make || exit -1
    - timeout: 300
    - unless: test -x /tmp/ebbrt/baremetal/ext/EbbRT-toolchain/install/bin/x86_64-pc-ebbrt-g++
    - require:
        - git: https://github.com/sesa/ebbrt.git

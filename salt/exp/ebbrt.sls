include:
  - qemu
  - khpy.start
  - misc.perf

ebbrt-build-depends:
  pkg.installed:
    - refresh: true
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

g++5repo:
  cmd.run: 
    - name: add-apt-repository ppa:ubuntu-toolchain-r/test

g++-4.9:
  pkg.installed:
    - name: g++-4.9
    - refresh: true
    - require:
        - cmd: add-apt-repository ppa:ubuntu-toolchain-r/test

g++-4.9_link:
  cmd.run:
    - name: ln -f -s /usr/bin/g++-4.9 /usr/bin/g++
    - require:
        - pkg: ebbrt-build-depends 
        - pkg: g++-4.9 


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
        ./configure || exit -1
        make -j {{salt['grains.get']('num_cpus', '1')}} || exit -1
        make install
    - timeout: 300
    - unless: test -x /usr/local/bin/capnp
    - require:
        - archive: extract-capnproto-tarball
        - pkg: ebbrt-build-depends 
        - cmd: g++-4.9_link

echo export EBBRT_SRCDIR=/tmp/ebbrt >> /root/.bashrc:
  cmd.run: []

echo export EBBRT_NODE_ALLOCATOR_DEFAULT_ARGUMENTS=\"--pin 6-11\" >> /root/.bashrc:
  cmd.run: []

        
https://github.com/jmcadden/ebbrt.git:
  git.latest:
    - rev: khpy_cmd 
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
    - user: root
    - unless: test -x /tmp/ebbrt/baremetal/ext/EbbRT-toolchain/install/bin/x86_64-pc-ebbrt-g++
    - require:
        - git: https://github.com/jmcadden/ebbrt.git

install-git:
  pkg.installed:
    - name: python-git

install-automake:
  pkg.installed:
    - name: automake

install-build-essential:
  pkg.installed:
    - name: build-essential

install-libtool:
  pkg.installed:
    - name: libtool
      
extract-capnproto-tarball:
  archive.extracted:
    - name: /tmp/capnproto
    - source: https://github.com/sandstorm-io/capnproto/archive/v0.4.0.tar.gz
    - source_hash: md5=30e7f69d2ca532be7089127fa8e8eb01
    - archive_format: tar
    - tar_options: z

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
        - pkg: install-automake
        - pkg: install-build-essential
        - pkg: install-git
        - pkg: install-libtool
        - archive: extract-capnproto-tarball
        
https://github.com/sesa/ebbrt.git:
  git.latest:
    - target: /tmp/ebbrt
    - user: root
    - submodules: true
      
https://github.com/sesa/ebbrt-memcached.git:
  git.latest:
    - target: /tmp/ebbrt-memcached
    - user: root

ebbrt-memcached-built:
  cmd.run:
    - cwd: /tmp/ebbrt-memcached
    - name: |
        make -j {{salt['grains.get']('num_cpus', 'a')}} || exit -1
    - env:
      - EBBRT_SRCDIR: '/tmp/ebbrt'
    - timeout: 300
    - unless: test -x /tmp/ebbrt-memcached/baremetal/build/Release/mcd.elf32
    - require:
        - pkg: install-git
        - pkg: install-automake
        - pkg: install-build-essential
        - cmd: install-capnproto
        - git: https://github.com/sesa/ebbrt.git
        - git: https://github.com/sesa/ebbrt-memcached.git
          

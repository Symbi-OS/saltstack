install-build-essential:
  pkg.installed:
    - name: build-essential

install-pkg-config:
  pkg.installed:
    - name: pkg-config

install-zlib1g-dev:
  pkg.installed:
    - name: zlib1g-dev

install-libglib2.0-dev:
  pkg.installed:
    - name: libglib2.0-dev

install-autoconf:
  pkg.installed:
    - name: autoconf

install-libtool:
  pkg.installed:
    - name: libtool

extract-qemu-tarball:
  archive.extracted:
    - name: /tmp/qemu
    - source: http://wiki.qemu-project.org/download/qemu-2.4.0.tar.bz2
    - source_hash: md5=186ee8194140a484a455f8e3c74589f4
    - archive_format: tar
    - tar_options: j
      
install-qemu:
  cmd.run:
    - name: |
        ./configure --target-list=x86_64-softmmu --enable-vhost-net --enable-kvm || exit -1
        make -j {{salt['grains.get']('num_cpus', '1')}} || exit -1
        make install
    - cwd: /tmp/qemu/qemu-2.4.0
    - timeout: 300
    - unless: test -x /usr/local/bin/qemu-system-x86_64
    - require:
        - pkg: install-build-essential
        - pkg: install-pkg-config
        - pkg: install-zlib1g-dev
        - pkg: install-libglib2.0-dev
        - pkg: install-autoconf
        - pkg: install-libtool
        - archive: extract-qemu-tarball  

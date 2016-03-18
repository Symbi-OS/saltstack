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
#--prefix=/usr/local --target-list=x86_64-softmmu --enable-vhost-net --enable-kvm --disable-linux-user --disable-vnc --disable-bluez --disable-brlapi --disable-curl --disable-curses --disable-fdt --without-system-pixman --disable-sdl --disable-uuid --disable-vnc --disable-xen --disable-linux-aio --disable-cap-ng --disable-xfsctl --disable-rdma --disable-spice --disable-rbd --disable-libusb --disable-glx --disable-zlib-test --disable-lzo --disable-snappy --disable-guest-agent --disable-tools --disable-libiscsi --disable-libnfs --disable-seccomp --disable-glusterfs --disable-archipelago --disable-gtk --disable-vte --disable-tpm --disable-libssh2 --disable-vhdx --disable-quorum --enable-numa --disable-qom-cast-debug --disable-guest-base --disable-pie --disable-attr
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

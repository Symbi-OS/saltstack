apt-get update:
  cmd.run: []

include:
  - baremetal.rsa

ebbrt-build-depends:
  pkg.installed:
    - refresh: true
    - timeout: 300
    - pkgs:
      - build-essential
      - git
      - nano

kexec-tools-tarball:
  archive.extracted:
    - name: /tmp/kexec
    - source: https://github.com/horms/kexec-tools/archive/v2.0.14.tar.gz
    - source_hash: md5=ce841b0d4c96cda2762e67a295ac0b46
    - archive_format: tar
    - tar_options: z
    - unless: test -d /tmp/kexec

install-kexec-tools:
  cmd.run:
    - cwd: /tmp/kexec/kexec-tools-2.0.14
    - name: |
        ./bootstrap || exit -1
        ./configure --prefix=/usr/local --sbindir=/usr/sbin || exit -1
        make install || exit -1
    - timeout: 300
    - unless: test -x /usr/sbin/kexec
    - require:
      - archive: kexec-tools-tarball
      - pkg: ebbrt-build-depends
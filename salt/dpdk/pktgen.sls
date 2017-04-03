pktgen-depends:
  pkg.installed:
    - refresh: true
    - timeout: 300
    - pkgs:
       - libpcap-dev
       - lua5.2 

extract-pktgen:
  archive.extracted:
    - name: /root/pktgen
    - source: http://dpdk.org/browse/apps/pktgen-dpdk/snapshot/pktgen-3.2.0.tar.xz
    - source_hash: md5=75cb8b3c5f5cd77426940a6673fe2d73
    - archive_format: tar
    - tar_options: -x --strip-components=1
    - unless: test -d /root/pktgen

build-pktgen:
  cmd.run: 
    - cwd: /root/pktgen
    - name: make -j
    - env:
      - RTE_SDK: /dpdk/share/dpdk
      - RTE_TARGET: x86_64-native-linuxapp-gcc
    - require:
      - archive: extract-pktgen

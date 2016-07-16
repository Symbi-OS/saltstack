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
    - source: http://dpdk.org/browse/apps/pktgen-dpdk/snapshot/pktgen-dpdk-3.0.06.tar.gz
    - source_hash: md5=2e22b58527bdde70e52b813912436b45
    - archive_format: tar
    - tar_options: z --strip-components=1
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

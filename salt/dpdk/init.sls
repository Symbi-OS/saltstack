include:
  - misc.hostname

dpdk-depends:
  pkg.installed:
    - refresh: true
    - timeout: 300
    - pkgs:
       - build-essential
       - gcc-multilib
       - pciutils
       - linux-headers-4.4.0-21-generic

extract-dpdk:
  archive.extracted:
    - name: /root/dpdk_src
    - source: http://fast.dpdk.org/rel/dpdk-16.11.1.tar.xz
    - source_hash: md5=b867eab1f357340d105e92f2e9d8f7de
    - archive_format: tar
    - tar_options: -x --strip-components=1
    #- unless: test -d /root/dpdk_src

#config-2M-pages:
#  cmd.run: |
#    - name: |
#      echo 1024 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
#      echo 1024 > /sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages

modprobe vfio-pci:
  cmd.run: []

mount-hugepages:
  cmd.run:
    - unless: test -d /mnt/huge
    - name: |
        mkdir /mnt/huge || exit -1
        mount -t hugetlbfs nodev /mnt/huge || exit -1

build-dpdk:
  cmd.run:
    - cwd: /root/dpdk_src
    - name: make -j install T=x86_64-native-linuxapp-gcc 
    - env:
      - DESTDIR: /dpdk
    - require:
        - pkg: dpdk-depends
        - archive: extract-dpdk

build-helloworld:
  cmd.run: 
    - cwd: /root/dpdk_src/examples/helloworld
    - name: make -j
    - env:
      - RTE_SDK: /dpdk/share/dpdk
      - RTE_TARGET: x86_64-native-linuxapp-gcc
    - require:
      - cmd: build-dpdk 

/root/dpdk_src/tools/dpdk-devbind.py -s:
    cmd.run:
      - require:
        - archive: extract-dpdk

ebbrt-build-depends:
  pkg.installed:
    - refresh: true
    - pkgs:
       - automake
       - netcat
       - build-essential
       - git
       - libtool 
       - cmake 
       - texinfo

#https://github.com/sesa/ebbrt.git:
https://github.com/salibrandi/ebbrt.git:
  git.latest:
    - target: /tmp/ebbrt
    - user: root
    - submodules: true
    - require:
        - pkg: ebbrt-build-depends 

ebbrt-toolchain-fetched:
  cmd.run:
    - cwd: /tmp/ebbrt/toolchain
    - name: make -j || exit -1
    - timeout: 2000
    - unless: test -x /tmp/ebbrt/toolchain/sysroot/usr/bin/x86_64-pc-ebbrt-g++
    - require:
      - git: https://github.com/salibrandi/ebbrt.git


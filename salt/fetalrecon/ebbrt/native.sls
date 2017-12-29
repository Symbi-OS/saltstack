include:
  - qemu
  - qemu.tap
  - ebbrt.native

fr-depends:
  pkg.installed:
    - pkgs: 
      - cmake 
      - libgsl0-dev
      - libboost-program-options-dev

https://github.com/SESA/EbbRT-fetalRecon.git:
  git.latest:
    - target: /tmp/EbbRT-fetalRecon
    - submodules: true
    - user: root
    - require:
        - pkg: fr-depends 

mkdirs:
  cmd.run:
    - name: |
        mkdir -p /tmp/EbbRT-fetalRecon/build/bm
    - require:
      - git: https://github.com/SESA/EbbRT-fetalRecon.git

nativeCmake:
  cmd.run:
    - cwd: /tmp/EbbRT-fetalRecon/build/bm
    - env:
      - EBBRT_SYSROOT: '/tmp/ebbrt/toolchain/sysroot'
    - name: |
        cmake -DCMAKE_TOOLCHAIN_FILE=/tmp/ebbrt/toolchain/sysroot/usr/misc/ebbrt.cmake -DCMAKE_PREFIX_PATH=/tmp/ebbrt/toolchain/sysroot -DCMAKE_BUILD_TYPE=Release ../../
    - unless:
      - exists: /tmp/EbbRT-fetalRecon/build/bm/reconstruction.elf32 
    - require:
      - git: https://github.com/SESA/EbbRT-fetalRecon.git
      - cmd: mkdirs

nativeMake:
  cmd.run:
    - cwd: /tmp/EbbRT-fetalRecon/build/bm
    - env:
      - EBBRT_SYSROOT: '/tmp/ebbrt/toolchain/sysroot'
    - name: |
        make -j
    - require:
      - cmd: nativeCmake 

/root/spawn.sh:
  file.managed:
  - source: salt://fetalrecon/ebbrt/spawn.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

/root/spawn_remote.sh:
  file.managed:
  - source: salt://fetalrecon/ebbrt/spawn_remote.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

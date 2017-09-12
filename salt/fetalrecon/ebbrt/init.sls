include:
  - ebbrt

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

fetalReconinstall:
  cmd.run:
    - cwd: /tmp/EbbRT-fetalRecon
    - env:
      - EBBRT_SYSROOT: '/tmp/ebbrt/toolchain/sysroot'
      - CMAKE_PREFIX_PATH: '/tmp/ebbrt/install'
    - name: |
        make -j all || exit -1
    - require:
      - git: https://github.com/SESA/EbbRT-fetalRecon.git

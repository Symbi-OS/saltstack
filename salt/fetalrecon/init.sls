fr-depends:
  pkg.installed:
    - pkgs: 
      - cmake 
      - libgsl0-dev
      - libboost-program-options-dev
      - libboost-serialization-dev
      - libboost-thread-dev

https://github.com/SESA/fetalReconstruction.git:
  git.latest:
    - target: /tmp/fetalReconstruction
    - submodules: true
    - user: root
    - require:
        - pkg: fr-depends 

# TODO: Need target to build fetalReconstruction for linux

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

fetalrecon-mkdir:
  cmd.run:
    - name: |
       	mkdir /tmp/fetalReconstruction/build
    - require:
      - git: https://github.com/SESA/fetalReconstruction.git

fetalrecon-build:
  cmd.run:
    - name: |
       	cmake ../source -DCMAKE_BUILD_TYPE=Release && make -j
    - cwd: /tmp/fetalReconstruction/build
    - require:
      - cmd: fetalrecon-mkdir
      - pkg: fr-depends 

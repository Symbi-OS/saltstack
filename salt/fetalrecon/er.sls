er-depends:
  pkg.installed:
    - pkgs: 
      - git
      - build-essential 
      - cmake 
      - nodejs
      - npm
      - python-setuptools
      - libgsl0-dev
      - libboost-program-options-dev
      - libboost-thread-dev
      - libboost-serialization-dev

https://github.com/SESA/ER.git:
  git.latest:
    - target: /tmp/ER
    - user: root
    - submodules: true
    - require:
        - pkg: er-depends 

fetalrecon-build:
  cmd.run:
    - cwd: /tmp/ER/ext/fetalReconstruction/source
    - name: |
        mkdir build || exit -1
        cd build || exit -1
        cmake .. || exit -1
        make -j || exit -1
    - require:
      - git: https://github.com/SESA/ER.git

er-build:
  cmd.run:
    - cwd: /tmp/ER/
    - name: |
        npm install || exit -1
        mkdir -p public/recon || exit -1
        mkdir -p transactions || exit -1
        mkdir -p uploads || exit -1
        ln -sf `which nodejs` /usr/bin/node 
    - require:
      - git: https://github.com/SESA/ER.git
      - pkg: er-depends

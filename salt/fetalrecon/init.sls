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
    - rev: cpu
    - target: /tmp/fetalReconstruction
    - submodules: true
    - user: root
    - require:
        - pkg: fr-depends 

# enable kh / disable dnsmasq 
# ebbrt srcdir
# cd /source/build
# cmake -DCMAKE_C_COMPILER=gcc-4.8 -DCMAKE_CXX_COMPILER=g++-4.8
# -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTS=OFF -DBUILD_TESTING=OFF
# -DBUILD_WITH_TBB=OFF  ..
# make -j12
# cd /ext/irtk-serialize/
# make -j12 Release
# /source/bin/runStack.sh 

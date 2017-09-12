fr-depends:
  pkg.installed:
    - pkgs: 
      - cmake 

https://github.com/handong32/ebbrt-contrib.git:
  git.latest:
    - rev: runmoc
    - target: /tmp/ebbrt-contrib
    - submodules: true
    - user: root
    - require:
        - pkg: fr-depends 


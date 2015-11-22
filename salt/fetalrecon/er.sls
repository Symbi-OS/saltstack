er-depends:
  pkg.installed:
    - pkgs: 
      - build-essentials 
      - cmake 
      - nodejs

https://github.com/SESA/ER.git:
  git.latest:
    - target: /tmp/ER
    - user: root
    - submodules: true
    - require:
        - pkg: er-depends 

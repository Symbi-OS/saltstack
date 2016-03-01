include:
  - misc.resolvconf
git:
  pkg.installed:
    - name: git 
    - require:
      - sls: misc.resolvconf

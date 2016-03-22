packages:
  pkg.installed:
    - refesh: true
    - pkgs:
      - python-git
      - bridge-utils

git-clone-khpy:
  git.latest:
    - name: https://github.com/SESA/khpy.git
    - target: /opt/khpy
    - user: root
    - require:
      - pkg: packages 

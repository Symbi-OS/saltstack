khpy-depends:
  pkg.installed:
    - pkgs: 
      - git 
      - python-git
      - dnsmasq 
      - bridge-utils 
      - tcl
      - tk 
      - xterm 

git-clone-khpy:
  git.latest:
    - name: http://github.com/SESA/khpy.git
    - target: /opt/khpy
    - user: root

/opt/khpy/khs.cfg:
  file.managed:
  - source: salt://khpy/local_server_config
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - requires:
    - git-clone-khpy

/opt/khpy/khdb.cfg:
  file.managed:
  - source: salt://khpy/local_db_config
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - requires:
    - git-clone-khpy

/opt/khpy/modules/qemu_server.cfg:
  file.managed:
  - source: salt://khpy/local_server_qemu_config
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - requires:
    - git-clone-khpy

khs-install:
  - cmd.run:
    - cwd: /opt/khpy
    - name: ./khs install
    - unless: test -d /opt/khdb
    - require:
      - pkg: git-clone-khpy

khs-start:
  - cmd.run:
    - cwd: /opt/khpy
    - name: ./khs start & 
    - unless: test ! -d /opt/khdb
    - require:
      - pkg: git-clone-khpy
      - pkg: khs-install 

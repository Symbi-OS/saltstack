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
    - name: https://github.com/SESA/khpy.git
    - target: /opt/khpy
    - user: root

dnsmasq:
  service.dead: []

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

/opt/khpy/modules/qemu_client.cfg:
  file.managed:
  - source: salt://khpy/local_client_qemu_config
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - requires:
    - git-clone-khpy
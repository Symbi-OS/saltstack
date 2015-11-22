khpy-depends:
  pkg.installed:
    - pkgs: 
      - vlan
      - git 
      - python-git
      - dnsmasq 
      - bridge-utils 
      - tcl
      - tk 
      - xterm 
      - nodejs
      - npm
      - nfs-client

modprobe 8021q:
  cmd.run: []
vconfig add eth1 1045:
  cmd.run: []
ip link set dev eth1.1045 up:
  cmd.run: []
mkdir /opt:
  cmd.run: []
mount -t nfs salt:/opt /opt:
  cmd.run: []
ln -s /usr/bin/nodejs node:
  cmd.run: []

git-clone-khpy:
  git.latest:
    - rev: moc
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

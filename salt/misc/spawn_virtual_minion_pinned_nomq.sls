include:
  - qemu
  - qemu.bridge

psmisc:
  pkg.installed: [] 

/tmp/spawn_virtual_minion_pinned_nomq.sh:
  file.managed:
  - source: salt://misc/spawn_virtual_minion_pinned_nomq.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

spawn_virtual_minion:
  cmd.run:
    - name: /tmp/spawn_virtual_minion_pinned_nomq.sh&
    - cwd: /tmp
    - timeout: 300
    - requires:
      - sls: qemu
      - sls: qemu.bridge
      - file: /tmp/spawn_virtual_minion_pinned_nomq.sh

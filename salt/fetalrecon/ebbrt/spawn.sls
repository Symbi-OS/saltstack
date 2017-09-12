/root/spawn.sh:
  file.managed:
  - source: salt://fetalrecon/ebbrt/spawn.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

/root/spawn_remote.sh:
  file.managed:
  - source: salt://fetalrecon/ebbrt/spawn_remote.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

/tmp/start:
  file.managed:
  - source: salt://docker/swarm/start
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

start:
  cmd.run:
  - name: /tmp/start &
  - requires:
    - file: /tmp/start

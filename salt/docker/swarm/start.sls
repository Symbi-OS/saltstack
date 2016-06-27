include:
  - docker.swarm.init 

/tmp/start:
  file.managed:
  - source: salt://docker/swarm/start
  - template: jinja
  - user: root
  - group: root
  - mode: 755 
  - require:
    - sls: docker.swarm.init

start:
  cmd.run:
  - name: /tmp/start &
  - requires:
    - sls: docker.swarm.init
    - file: /tmp/start

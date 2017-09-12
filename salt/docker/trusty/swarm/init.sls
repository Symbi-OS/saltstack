include:
  - misc.hostname
  - docker.trusty.weave

/etc/default/docker.swarm:
  file.managed:
    - name: /etc/default/docker
    - source: salt://docker/swarm/default
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - require:
      - sls: docker.weave 

docker-swarm-running:
  cmd.run:
    - name: service docker restart
    - onchanges:
      - file: /etc/default/docker.swarm

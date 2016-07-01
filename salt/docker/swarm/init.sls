include:
  - misc.hostname
  - docker.install

/etc/systemd/system/docker.service:
  file.managed:
    - source: salt://docker/swarm/docker.service
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true

systemctl daemon-reload:
  cmd.run: []

start_docker:
  cmd.run:
    - name: systemctl restart docker
    - require:
      - sls: docker.install
      - cmd: systemctl daemon-reload
      - file: /etc/systemd/system/docker.service

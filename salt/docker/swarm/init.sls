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

docker-service:
  service.running:
    - name: docker
    - enable: true
    - reload: true
    - require:
      - sls: docker.install
      - cmd: systemctl daemon-reload
    - watch:
      - file: /etc/systemd/system/docker.service

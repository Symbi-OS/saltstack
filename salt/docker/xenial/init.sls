include:
  - docker/xenial/install

/etc/systemd/system/docker.service:
  file.managed:
    - source: salt://docker/xenial/docker.service
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
      - sls: docker/xenial/install
      - cmd: systemctl daemon-reload
    - watch:
      - file: /etc/systemd/system/docker.service

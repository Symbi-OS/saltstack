include:
  - docker/trusty/install

/etc/default/docker:
  file.managed:
    - source: salt://docker/trusty/default
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true

docker-service:
  service.running:
    - name: docker
    - enable: true
    - reload: true
    - require:
      - sls: docker/trusty/install
    - watch:
      - file: /etc/default/docker

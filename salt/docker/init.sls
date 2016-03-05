include:
  - docker/install

docker-service:
  service.running:
    - name: docker
    - enable: true
    - reload: true
    - require:
      - sls: docker/install
    - watch:
      - file: /etc/default/docker

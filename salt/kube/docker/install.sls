include:
  - kube/docker/bridge
  - docker/install

kube-docker-config-update:
  file.managed:
    - name: /etc/default/docker 
    - source: salt://kube/docker/default
    - template: jinja
    - replace: true
    - user: root
    - group: root
    - mode: 755
    - makedirs: true
    - require:
        - sls: kube/docker/bridge
        - sls: docker/install 

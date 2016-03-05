include:
  - kube/docker/install

kube-start-docker:
  service.running:
    - name: docker
    - reload: True
    - require:
      - sls: kube/docker/install 

include:
  - misc.hostname
  - docker.xenial.weave

docker-swarm-running:
  cmd.run:
    - name: service docker restart

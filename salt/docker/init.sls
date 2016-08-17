include:
  - docker/trusty

docker-install:
  cmd.run:
    - name: test -d /
    - required:
      - sls: docker/trusty

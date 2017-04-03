{% if grains['os'] == 'Ubuntu' %}
{% if grains['oscodename'] == 'trusty' %}
include:
  - docker/trusty

docker-install:
  cmd.run:
    - name: test -d /
    - required:
      - sls: docker/trusty
{% elif grains['oscodename'] == 'xenial' %}
include:
  - docker/xenial

docker-install:
  cmd.run:
    - name: test -d /
    - required:
      - sls: docker/xenial
{% endif %}
{% endif %}

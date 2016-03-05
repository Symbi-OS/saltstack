apparmor:
  pkg.installed:
    - name: apparmor
    - refresh: true

apt-transport-https:
  pkg.installed:
    - name: apt-transport-https
    - refresh: true

bridge-utils:
  pkg.installed:
    - name: bridge-utils
    - refresh: true

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

/etc/apt/sources.list.d/docker.list:
  pkgrepo.managed:
   - name: deb https://apt.dockerproject.org/repo ubuntu-trusty main
   - dist: ubuntu-trusty
   - file: /etc/apt/sources.list.d/docker.list
   - keyserver: hkp://pgp.mit.edu:80 
   - keyid: 58118E89F3A912897C070ADBF76221572C52609D
   - refresh_db: true
   - require:
      - pkg: apt-transport-https
   - require-in:
      - pkg: docker-engine

docker-engine:
  pkg.installed:
    - fromrepo: ubuntu-trusty
    - name: docker-engine
    - refresh: true
    - require:
      - pkg: apparmor
      - pkg: bridge-utils

docker-service:
  service.running:
    - name: docker
    - enable: true
    - reload: true
    - watch:
      - file: /etc/default/docker

/etc/default/docker:
  file.managed:
    - source: salt://docker/default
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true


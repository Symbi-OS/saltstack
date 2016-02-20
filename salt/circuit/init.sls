net.ipv4.icmp_echo_ignore_broadcasts:
  sysctl.present:
    - value: 0

circuit-depends:
  pkg.installed:
    - pkgs: 
      - git 
      - golang

/usr/local/bin/circuit:
  cmd.run:
    - name: go get github.com/gocircuit/circuit/cmd/circuit
    - env: 
      - GOPATH: /usr/local

/etc/default/circuit:
  file.managed:
    - source: salt://circuit/default
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true

/etc/init.d/circuit:
  file.managed:
    - source: salt://circuit/initd
    - user: root
    - group: root
    - mode: 755
    - makedirs: true

circuit:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/default/circuit
      - file: /etc/init.d/circuit
    - require:
      - file: /etc/default/circuit
      - file: /etc/init.d/circuit

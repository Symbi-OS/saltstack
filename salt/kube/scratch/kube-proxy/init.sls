/usr/local/bin/kube-proxy:
  file.managed:
    - source: salt://kube/kube-bins/kube-proxy
    - user: root
    - group: root
    - mode: 755

/etc/default/kube-proxy:
  file.managed:
    - source: salt://kube/kube-proxy/default
    - template: jinja
    - user: root
    - group: root
    - mode: 644

kube-proxy:
  group.present:
    - system: True
  user.present:
    - system: True
    - gid_from_name: True
    - shell: /sbin/nologin
    - home: /var/kube-proxy
    - require:
      - group: kube-proxy

/etc/init.d/kube-proxy:
  file.managed:
    - source: salt://kube/kube-proxy/initd
    - user: root
    - group: root
    - mode: 755

/var/lib/kube-proxy/kubeconfig:
  file.managed:
    - source: salt://kube/kube-proxy/kubeconfig
    - user: root
    - group: root
    - mode: 400
    - makedirs: true

kube-proxy-service:
  service.running:
    - name: kube-proxy
    - enable: True
    - reload: True
    - watch:
      - file: /etc/default/kube-proxy
      - file: /etc/init.d/kube-proxy
      - file: /var/lib/kube-proxy/kubeconfig
    - require:
      - file: /etc/init.d/kube-proxy

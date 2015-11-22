/usr/local/bin/kubectl:
  file.managed:
    - source: salt://kube/kube-bins/kubectl
    - user: root
    - group: root
    - mode: 755
    - makedirs: true

/etc/default/kubelet:
  file.managed:
    - source: salt://kube/kubelet/default
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true

/usr/local/bin/kubelet:
  file.managed:
    - source: salt://kube/kube-bins/kubelet
    - user: root
    - group: root
    - mode: 755
    - makedirs: true

/var/lib/kubelet/kubeconfig:
  file.managed:
    - source: salt://kube/kubelet/kubeconfig
    - user: root
    - group: root
    - mode: 400
    - makedirs: true

/etc/init.d/kubelet:
  file.managed:
    - source: salt://kube/kubelet/initd
    - user: root
    - group: root
    - mode: 755
    - makedirs: true

kubelet:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/default/kubelet
      - file: /usr/local/bin/kubelet
      - file: /var/lib/kubelet/kubeconfig
      - file: /etc/init.d/kubelet
    - require:
      - file: /usr/local/bin/kubelet
      - file: /var/lib/kubelet/kubeconfig
      - file: /etc/default/kubelet
      - file: /etc/init.d/kubelet

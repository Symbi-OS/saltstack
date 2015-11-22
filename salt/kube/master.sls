/etc/kubernetes/manifests/kube-system-base.yaml:
  file.managed:
    - source: salt://kube/manifests/kube-system-base.yaml
    - template: jinja
    - user: root
    - group: root
    - mode: 755

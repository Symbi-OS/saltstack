/etc/kubernetes/manifests:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755
    - makedirs: true

/opt/kubernetes:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755
    - makedirs: true

/etc/hosts:
  file.append:
    - text: 
      - {{ salt['pillar.get']('kube-master', '127.0.0.1') }}     kube-master 

/etc/kubernetes/manifests/kube-proxy.yaml:
  file.managed:
    - source: salt://kube/manifests/kube-proxy.yaml
    - template: jinja
    - user: root
    - group: root
    - mode: 755

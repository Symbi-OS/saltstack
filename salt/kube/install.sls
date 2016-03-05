{% if grains['id'] == pillar['kube-master'] %}
/etc/kubernetes/manifests/kube-system-base.yaml:
  file.managed:
    - source: salt://kube/manifests/kube-system-base.yaml
    - template: jinja
    - user: root
    - group: root
    - mode: 755
    - makedirs: true
{% endif %}

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
    - makedirs: true

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

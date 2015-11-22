include:
    - docker
    - kube/common 
    - kube/docker/config
{% if grains['id'] == pillar['kube-master'] %}
    - kube/master
{% endif %}
    - kube/kubelet 

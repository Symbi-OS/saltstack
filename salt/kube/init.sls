include:
  - kube/docker 
  - kube/install 

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
      - sls: kube/docker
      - sls: kube/install

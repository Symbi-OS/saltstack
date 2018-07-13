include:
  - misc.hostname

ebbrt-build-depends:
  pkg.installed:
    - pkgs:
       - bc
       - jq 

https://github.com/jmcadden/whisk_contrib.git:
  git.latest:
    - target: /root/whisk_contrib
    - user: root

kumo_ssh_setup:
  cmd.run:
    - name: |
        cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
        echo 'StrictHostKeyChecking no' >> ~/.ssh/config
        echo 'UserKnownHostsFile=/dev/null' >> ~/.ssh/config
        ln -s ~/incubator-openwhisk/ansible/environments/kumo/hosts ~/ow_hosts

kumo_openwhisk_setup:
  cmd.run:
    - name: |
        cd /root/incubator-openwhisk
        git remote add jmcadden https://github.com/jmcadden/incubator-openwhisk.git
        git fetch jmcadden
        git checkout core/invoker/Dockerfile
        git checkout jmcadden/master

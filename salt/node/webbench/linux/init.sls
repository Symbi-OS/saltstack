linux-node-build-depends:
  pkg.installed:
    - refresh: true
    - timeout: 300
    - pkgs:
        - build-essential
        - git
        
https://github.com/sesa/ebbrt-node-app.git:
  git.latest:
    - submodules: True
    - target: /tmp/ebbrt-node
    - user: root

linux-node-built:
  cmd.run:
    - cwd: /tmp/ebbrt-node
    - name: |
        make -j {{salt['grains.get']('num_cpus', '1')}} linux || exit -1
    - unless: test -x /tmp/ebbrt-node/node/node
    - timeout: 600
    - require:
        - pkg: linux-node-build-depends

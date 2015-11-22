install-git:
  pkg.installed:
    - name: python-git

install-scons:
  pkg.installed:
    - name: scons

install-libevent-dev:
  pkg.installed:
    - name: libevent-dev

install-gengetopt:
  pkg.installed:
    - name: gengetopt

install-libzmq-dev:
  pkg.installed:
    - name: libzmq-dev      

install-build-essential:
  pkg.installed:
    - name: build-essential

https://github.com/leverich/mutilate.git:
  git.latest:
    - target: /tmp/mutilate
    - user: root

mutilate_installed:
  cmd.run:
    - cwd: /tmp/mutilate
    - user: root
    - name: |
        scons || exit -1
        cp /tmp/mutilate/mutilate /usr/local/bin
    - require:
        - pkg: install-git
        - pkg: install-scons
        - pkg: install-libevent-dev
        - pkg: install-gengetopt
        - pkg: install-libzmq-dev
        - pkg: install-build-essential

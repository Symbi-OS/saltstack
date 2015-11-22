install-git:
  pkg.installed:
    - name: python-git
      
install-automake:
  pkg.installed:
    - name: automake

install-build-essential:
  pkg.installed:
    - name: build-essential

install-libevent-dev:
  pkg.installed:
    - name: libevent-dev

https://github.com/sesa/memcached.git:
  git.latest:
    - rev: pin_threads
    - target: /tmp/memcached
    - user: root
    - require:
        - pkg: python-git 

memcached_installed:
  cmd.run:
    - cwd: /tmp/memcached
    - name: |
        ./autogen.sh || exit -1
        ./configure || exit -1
        make -j {{salt['grains.get']('num_cpus', '1')}} || exit -1
        make install
    - timeout: 300
    - unless: test -x /usr/local/bin/memcached
    - require:
        - pkg: install-automake
        - pkg: install-build-essential
        - pkg: install-git
        - pkg: install-libevent-dev

memcached-build-depends:
  pkg.installed:
    - refresh: true
    - pkgs:
       - automake1.11
       - build-essential
       - git
       - libevent-dev

https://github.com/sesa/memcached.git:
  git.latest:
    - rev: pin_threads
    - target: /tmp/memcached
    - user: root
    - require:
        - pkg: memcached-build-depends

memcached_installed:
  cmd.run:
    - cwd: /tmp/memcached
    - name: |
        ./autogen.sh || exit 1
        ./configure || exit 1
        make -j {{salt['grains.get']('num_cpus', '1')}} || exit 1
        make install
    - timeout: 300
    - unless: test -x /usr/local/bin/memcached
    - require:
        - pkg: memcached-build-depends
        - git: https://github.com/sesa/memcached.git

/tmp/mcd_server_ip.sh:
  file.managed:
  - source: salt://memcached/linux/server_ip.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755

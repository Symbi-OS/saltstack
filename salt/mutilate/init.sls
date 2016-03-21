mutilate-build-depends:
  pkg.installed:
    - refresh: true
    - pkgs:
      - python-git
      - scons
      - libevent-dev
      - gengetopt
      - libzmq-dev
      - build-essential

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
    - unless: test -x /usr/local/bin/mutilate
    - require:
      - pkg: mutilate-build-depends
      - git: https://github.com/leverich/mutilate.git

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
      - git

https://github.com/jmcadden/mutilate.git:
  git.latest:
    - target: /tmp/mutilate
    - user: root
    - require:
      - pkg: mutilate-build-depends

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
      - git: https://github.com/jmcadden/mutilate.git

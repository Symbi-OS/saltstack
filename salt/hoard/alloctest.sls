/tmp/start_alloc_test.sh:
  file.managed:
  - source: salt://hoard/alloctest.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

start_alloc_test:
  cmd.run:
    - name: /tmp/start_alloc_test.sh
    - cwd: /tmp
    - timeout: 3600
    - requires:
      - file: /tmp/start_alloc_test.sh
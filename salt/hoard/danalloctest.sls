/tmp/start_danalloc_test.sh:
  file.managed:
  - source: salt://hoard/danalloctest.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

start_danalloc_test:
  cmd.run:
    - name: /tmp/start_danalloc_test.sh
    - cwd: /tmp
    - timeout: 300
    - requires:
      - file: /tmp/start_danalloc_test.sh
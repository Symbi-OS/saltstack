/tmp/start_danalloc_test_oldebbrt.sh:
  file.managed:
  - source: salt://hoard/danalloctest_oldebbrt.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

start_danalloc_test_oldebbrt:
  cmd.run:
    - name: /tmp/start_danalloc_test_oldebbrt.sh
    - cwd: /tmp
    - timeout: 300
    - requires:
      - file: /tmp/start_danalloc_test_oldebbrt.sh
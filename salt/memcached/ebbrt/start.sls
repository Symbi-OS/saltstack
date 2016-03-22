/tmp/start_ebbrt_memcached:
  file.managed:
  - source: salt://memcached/ebbrt/start
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

start_ebbrt_memcached:
  cmd.run:
    - name: /tmp/start_ebbrt_memcached
    - cwd: /tmp
    - timeout: 300
    - requires:
      - file: /tmp/start_ebbrt_memcached

/tmp/start_osv_memcached.sh:
  file.managed:
  - source: salt://memcached/osv/start.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

start_ebbrt_memcached:
  cmd.run:
    - name: /tmp/start_osv_memcached.sh
    - cwd: /tmp
    - timeout: 300
    - requires:
      - file: /tmp/start_osv_memcached.sh

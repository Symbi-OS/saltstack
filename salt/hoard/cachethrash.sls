/tmp/start_cache_scratch.sh:
  file.managed:
  - source: salt://hoard/cachescratch.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

start_cache_scratch:
  cmd.run:
    - name: /tmp/start_cache_scratch.sh
    - cwd: /tmp
    - timeout: 300
    - requires:
      - file: /tmp/start_cache_scratch.sh

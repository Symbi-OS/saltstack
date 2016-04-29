include:
  - qemu.tap

/tmp/start_linux_memcached.sh:
  file.managed:
  - source: salt://memcached/linux/start.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

start_linux_memcached:
  cmd.run:
    - name: /tmp/start_linux_memcached.sh
    - cwd: /tmp
    - timeout: 300
    - requires:
      - file: /tmp/start_linux_memcached.sh

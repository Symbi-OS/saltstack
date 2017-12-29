/tmp/start_ebbrt_hoard.sh:
  file.managed:
  - source: salt://hoard/start.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

start_ebbrt_hoard:
  cmd.run:
    - name: /tmp/start_ebbrt_hoard.sh
    - cwd: /tmp
    - timeout: 3600
    - requires:
      - file: /tmp/start_ebbrt_hoard.sh

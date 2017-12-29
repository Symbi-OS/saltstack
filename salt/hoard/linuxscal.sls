/tmp/start_linux_scalability.sh:
  file.managed:
  - source: salt://hoard/linuxscal.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

start_linux_scalability:
  cmd.run:
    - name: /tmp/start_linux_scalability.sh
    - cwd: /tmp
    - timeout: 300
    - requires:
      - file: /tmp/start_linux_scalability.sh

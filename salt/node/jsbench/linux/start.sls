/tmp/start_linux_node.py:
  file.managed:
  - source: salt://node/jsbench/linux/start.py
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

start_linux_node:
  cmd.run:
    - name: /tmp/start_linux_node.py
    - cwd: /tmp
    - timeout: 300
    - requires:
      - file: /tmp/start_linux_node.py

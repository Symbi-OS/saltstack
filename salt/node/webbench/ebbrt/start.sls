/tmp/start_ebbrt_node.py:
  file.managed:
  - source: salt://node/webbench/ebbrt/start.py
  - template: jinja
  - user: root
  - group: root
  - mode: 755 

start_ebbrt_node:
  cmd.run:
    - name: /tmp/start_ebbrt_node.py
    - cwd: /tmp
    - timeout: 300
    - requires:
      - file: /tmp/start_ebbrt_node.py

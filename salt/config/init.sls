config:
  file.managed:
    - name: /tmp/config2
    - source: salt://config/config
    - template: jinja

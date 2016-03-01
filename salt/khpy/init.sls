include:
  - khpy.install 

/opt/khpy/khs.cfg:
  file.managed:
  - source: salt://khpy/local_server_config
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - require:
    - sls: khpy.install 

/opt/khpy/khdb.cfg:
  file.managed:
  - source: salt://khpy/local_db_config
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - require:
    - sls: khpy.install 

/opt/khpy/modules/qemu_server.cfg:
  file.managed:
  - source: salt://khpy/local_server_qemu_config
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - require:
    - sls: khpy.install 

/opt/khpy/modules/qemu_client.cfg:
  file.managed:
  - source: salt://khpy/local_client_qemu_config
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - require:
    - sls: khpy.install 

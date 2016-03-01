include:
  - khpy.install 
  - khpy.init 
  - misc.dnsmasq

/etc/init.d/khpy:
  file.managed:
    - source: salt://khpy/initd
    - user: root
    - group: root
    - mode: 755

khpy-service:
  service.running:
    - name: khpy
    - enable: True
    - reload: True
    - watch:
      - file: /etc/init.d/khpy
    - require:
      - file: /etc/init.d/khpy
      - sls: khpy.install 
      - sls: khpy.init 
      - sls: misc.dnsmasq

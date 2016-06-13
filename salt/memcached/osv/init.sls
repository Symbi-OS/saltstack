include:
  - qemu
  - qemu.bridge

psmisc:
  pkg.installed: [] 

/tmp/mcd_server_ip.sh:
  file.managed:
  - source: salt://memcached/osv/server_ip.sh
  - template: jinja
  - user: root
  - group: root
  - mode: 755

/tmp/osv_mcd.img:
  file.managed:
  - source: salt://memcached/osv/osv_mcd.img
  - user: root
  - group: root
  - mode: 755

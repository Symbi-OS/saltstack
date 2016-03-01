khs-install:
  cmd.run:
    - cwd: /opt/khpy
    - name: ./khs install
    - unless: test -d /opt/khdb

khs-start:
  cmd.run:
    - cwd: /opt/khpy
    - name: ./khs start & 
    - unless: test ! -d /opt/khdb
nfs-client:
  pkg.installed: []

mkdir /opt:
  cmd.run: []

mount -t nfs salt:/opt /opt:
  cmd.run: 
    - require:
      - pkg: nfs-client

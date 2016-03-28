nfs-client:
  pkg.installed: []

mount -t nfs salt:/opt /opt:
  cmd.run: 
    - require:
      - pkg: nfs-client

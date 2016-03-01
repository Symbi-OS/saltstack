dnsmasq:
  pkg.installed: [] 

kill-dnsmasq:
  service.dead:
    - name: dnsmasq
    - enable: False
    - require:
      - pkg: dnsmasq

vlan:
  pkg.installed: []

vlan-setup:
  cmd.run: 
    - name: |
        modprobe 8021q || exit 1
        ip link add link eth1 name eth1.1045 type vlan id 1045 || exit 1
        ip link set dev eth1.1045 up || exit 1
    - unless: up link show eth1.1045
    - require:
        - pkg: vlan

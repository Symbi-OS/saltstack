vlan:
  pkg.installed: []

vlan-setup:
  cmd.run: 
    - name: |
        modprobe 8021q || exit 1
        ip link add link {{salt['grains.get']('primary_interface')}} name {{salt['grains.get']('primary_interface')}}.1045 type vlan id 1045 || exit 1
        ip link set dev {{salt['grains.get']('primary_interface')}}.1045 up || exit 1
    - unless: up link show {{salt['grains.get']('primary_interface')}}.1045
    - require:
        - pkg: vlan

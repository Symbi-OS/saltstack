vlanconfig:
  cmd.run: 
    - name: |
        ip link show vhub && exit 0
        ip link add link {{salt['grains.get']('primary_interface')}} vhub type vlan proto 802.1Q id 1054 || exit 1
        ip link set vhub up || exit 1

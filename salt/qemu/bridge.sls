bridge-configured:
  cmd.run:
    - name: |
        ip link add name virtbr type bridge || exit 1
        ip link set virtbr up || exit 1
        ip addr add {{salt['grains.get']('id')}}/24 dev virtbr || exit 1
        ip addr flush eth1 && ip link set eth1 master virtbr 
        route add default gw {{salt['network.default_route']()[0]['gateway']}}
    - timeout: 60
    - unless: ip link show virtbr 

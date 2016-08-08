bridge-configured:
  cmd.run:
    - name: |
        ip link show dev virtbr && exit 0
        ip link add name virtbr type bridge || exit 1
        ip link set virtbr up || exit 1
        ip addr add {{salt['grains.get']('id')}}/24 dev virtbr || exit 1
        ip addr flush {{salt['grains.get']('primary_interface')}} && ip link set {{salt['grains.get']('primary_interface')}} master virtbr 
        route add default gw {{salt['network.default_route']()[0]['gateway']}}
    - timeout: 60

bridge-configured:
  cmd.run:
    - name: |
        ip link add name cbr0 type bridge || exit 1
        ip link set cbr0 up || exit 1
        ip addr add {{salt['grains.get']('id')}}/16 dev cbr0 || exit 1
        ip addr flush eth1 && ip link set eth1 master cbr0
        route add default gw {{salt['network.default_route']()[0]['gateway']}}
    - timeout: 60
    - unless: ip link show cbr0 

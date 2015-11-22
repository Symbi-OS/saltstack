install-bridge-utils:
  pkg.installed:
    - name: bridge-utils
      
bridge-configured:
  cmd.run:
    - name: |
        brctl addbr cbr0 || exit 1
        ip link set cbr0 up || exit 1
        ip addr add {{salt['grains.get']('id')}}/16 dev cbr0 || exit 1
        ip addr flush eth1 && brctl addif cbr0 eth1
        route add default gw {{salt['network.default_route']()[0]['gateway']}}
    - timeout: 60
#    - onlyif: brctl show cbr0 | grep 'No such device'
    - require:
        - pkg: install-bridge-utils
 
 

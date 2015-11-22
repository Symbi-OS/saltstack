install-bridge-utils:
  pkg.installed:
    - name: bridge-utils
      
bridge-configured:
  cmd.run:
    - name: |
        brctl addbr virtbr || exit 1
        ip link set virtbr up || exit 1
        ip addr add {{salt['grains.get']('id')}}/24 dev virtbr || exit 1
        ip addr flush eth1 && brctl addif virtbr eth1
        route add default gw {{salt['network.default_route']()[0]['gateway']}}
    - timeout: 60
    - onlyif: brctl show virtbr | grep 'No such device'
    - require:
        - pkg: install-bridge-utils
 
 

#!/usr/bin/env python
import salt.modules.network
import salt.modules.pillar

__salt__ = {
    'network.interfaces': salt.modules.network.interfaces,
    'network.ip_in_subnet': salt.modules.network.ip_in_subnet
}

def primary_interface():
    '''
    Return the primary interface
    '''
    primary_subnet = __pillar__.get('primary_subnet', '0.0.0.0/0')
    ifaces = __salt__['network.interfaces']()
    for iface in ifaces:
        for inet in ifaces[iface].get('inet', []):
            if 'address' in inet:
                if __salt__['network.ip_in_subnet'](inet['address'],primary_subnet):
                    return {'primary_interface': iface}
    return {}

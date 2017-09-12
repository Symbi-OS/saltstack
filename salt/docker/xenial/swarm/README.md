# How to launch Docker Swarm

### Set up swarm and install dependencies
```
$ salt <minion_id> state.apply docker.swarm
```

### Deploy Consul, Manager and Workers

Make sure to add the consul data to the pillar in the following way:

```
docker:
  kv:
    type: consul
    port: <port_no>
    host: <conul_ip>
```

To deploy execute the following:

```
$ salt <minion_id> state.apply docker.swarm.consul 
$ salt <minion_id> state.apply docker.swarm.manager
$ salt <minion_id> state.apply docker.swarm.worker 
```

### To execute with EbbRT

Before running any EbbRT application in the swarm make sure to export the following environment variables:

```
export EBBRT_NODE_ALLOCATOR_CUSTOM_NETWORK_IP_CMD="ip addr show weave | grep
'inet ' | cut -d ' ' -f 6”
export EBBRT_NODE_ALLOCATOR_CUSTOM_NETWORK_NODE_CONFIG="--net=weave -e
IFACE_DEFAULT=ethwe0"
```

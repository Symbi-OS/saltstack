# How to launch Docker Swarm

#### Set up swarm and install dependencies
```
    salt <minion_id> state.apply docker.swarm
```

#### Deploy Consul, Manager and Workers

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
    salt <minion_id> state.apply docker.swarm.consul 
    salt <minion_id> state.apply docker.swarm.manager
    salt <minion_id> state.apply docker.swarm.worker 
```

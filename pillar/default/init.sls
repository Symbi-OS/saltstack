mine_functions:
  network.interfaces: []
  status.uptime: []

primary_subnet: 192.168.1.0/24

docker:
  port: 2375
  type: experimental
  kv:
    type: consul
    port: 8500
  swarm:
    port: 4000

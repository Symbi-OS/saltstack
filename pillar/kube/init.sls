{% set masterip = '192.168.1.107' %}
kube-master: {{ masterip }}
kube-minions: 192.168.1.106
docker-subnet: 10.200.20.0/24
#docker-ip: 172.17.0.{{ grains['id'].rsplit('.',1)[1] }}
#docker-master: 172.17.0.{{ masterip.rsplit('.',1)[1] }}


{% set masterip = '192.168.1.106' %}
kube-master: {{ masterip }}
docker-subnet: 10.200.20.0/24
#kube-minions: 192.168.1.115
#docker-ip: 172.17.0.{{ grains['id'].rsplit('.',1)[1] }}
#docker-master: 172.17.0.{{ masterip.rsplit('.',1)[1] }}

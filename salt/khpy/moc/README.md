This state will install the kh service database (/opt/khdb) to a nfs mount run on
the salt master. 

### Configuration on nfs host:

   /etc/exports:
      /opt 192.168.1.0/24(rw,no_root_squash,async,insecure)

   service nfs start


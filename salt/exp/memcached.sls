base:
  'role:memcached':
    - match: grain
    - memcached.ebbrt
  'role:master':
    - match: grain
    - mutilate 
  'role:minion':
    - match: grain
    - mutilate 

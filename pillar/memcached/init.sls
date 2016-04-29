mine_functions:
  mcd_server_ip:
    - mine_function: cmd.run 
    - /bin/bash -c "/tmp/mcd_server_ip.sh"

memcached:
  cpus: 1 
  core_pin: '0'
  ram_gb:  4
  ram_mb:  4096
  mq_queues: 2
  mq_vectors: 6 
  vhost_pin_start: 6
  vhost_pin_inc: 1
mutilate:
  K_val:  'fb_key'
  V_val:  'fb_value'
  i_val:  'fb_ia'
  u_val:  '0.25'
  c_val:  '8'
  d_val:  '4'
  C_val:  '8'
  Q_val:  '1000'
  t_val:  '30'
  scan_val: '25000:500000:25000'

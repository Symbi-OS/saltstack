mine_functions:
  mcd_server:
    - mine_function: cmd.run 
    - /bin/bash -c "grep -s 'Dhcp Complete:'  /tmp/stdout | cut -d ' ' -f3"

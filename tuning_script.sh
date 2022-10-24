sudo ./salt/performance/disable_boost.py
sudo ./salt/performance/disable_ht.sh
sudo ./salt/performance/disable_cstates.sh
sudo cpupower set -b 0
sudo cpupower frequency-set -g performance

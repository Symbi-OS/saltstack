include:
  - qemu.bridge

tap-configured:
  cmd.run:
    - name: |
        ip tuntap add dev virttap mode tap multi_queue || exit -1
        ip link set virttap master virtbr 
        ip link set virttap up
    - timeout: 60
    - unless: ip link show dev virttap
    - require:
        - sls: qemu.bridge

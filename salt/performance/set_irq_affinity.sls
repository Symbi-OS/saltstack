disable-irq-balance:
  cmd.run:
    - name: "! pgrep irqbalance || pkill irqbalance"

{% if grains['virtual'] == 'physical'%}
salt://performance/set_irq_affinity_ixgbe.sh:
  cmd.script:
    - args: "-x all eth1"
{% elif grains['virtual'] == 'kvm'%}
salt://performance/set_irq_affinity_virtio.sh:
  cmd.script
{% endif %}

# This assumes the use of the acpi-cpufreq scaling driver. Some
# systems use intel_pstate instead which must be disabled some other
# way.
disable_boost:
  cmd.run:
    - name: echo '0' > /sys/devices/system/cpu/cpufreq/boost

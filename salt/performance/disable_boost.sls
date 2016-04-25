# This assumes the use of the acpi-cpufreq scaling driver. Some
# systems use intel_pstate instead which must be disabled some other
# way.
salt://performance/disable_boost.py:
  cmd.script

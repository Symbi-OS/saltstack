#!/usr/bin/env python

import os
import sys

acpi_cpufreq = '/sys/devices/system/cpu/cpufreq/boost'
intel_pstate = '/sys/devices/system/cpu/intel_pstate/no_turbo'
if os.path.isfile(acpi_cpufreq):
    with open(acpi_cpufreq, 'w') as f:
        f.write('0')
        print acpi_cpufreq + ' -> 0'
elif os.path.isfile(intel_pstate):
    with open(intel_pstate, 'w') as f:
        f.write('1')
        print intel_pstate + ' -> 1'
else:
    sys.exit('ERROR: Machine appears to be neither using acpi-cpufreq nor intel_pstate!')

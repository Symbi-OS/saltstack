#!/usr/bin/env python

import os
import subprocess

SUT = "\"*115\""

subprocess.call("salt -C " + SUT + " saltutil.refresh_pillar", shell=True)
subprocess.call("salt -C " + SUT + " saltutil.sync_grains", shell=True)
subprocess.call("/srv/scripts/clear_mine.sh", shell=True)
subprocess.call("salt -C " + SUT + " pkg.install psmic refresh=True", shell=True)
subprocess.call("salt -C " + SUT + " cmd.run \"killall qemu-system-x86_64\"", shell=True)
subprocess.call("salt -C " + SUT + " state.apply performance", shell=True)
subprocess.call("salt -C " + SUT + " state.apply node.jsbench.ebbrt", shell=True)
for i in range(0,100):
    out = os.open(str(i) + ".out", os.O_RDWR | os.O_CREAT)
    err = os.open(str(i) + ".err", os.O_RDWR | os.O_CREAT)
    p = subprocess.Popen("salt -C " + SUT + " state.apply node.jsbench.ebbrt.start", shell=True, stdout=out, stderr=err)
    p.wait()
    os.close(out)
    os.close(err)

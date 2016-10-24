#!/usr/bin/env python

import argparse
import os
import subprocess

parser = argparse.ArgumentParser(description='Run full node.js benchmark on Linux')
parser.add_argument('ip_addr', help='IP Address of system to test')
args = parser.parse_args()

subprocess.call("salt -C " + args.ip_addr + " saltutil.refresh_pillar", shell=True)
subprocess.call("salt -C " + args.ip_addr + " saltutil.sync_grains", shell=True)
subprocess.call("/srv/scripts/clear_mine.sh", shell=True)
subprocess.call("salt -C " + args.ip_addr + " pkg.install psmic refresh=True", shell=True)
subprocess.call("salt -C " + args.ip_addr + " cmd.run \"killall qemu-system-x86_64\"", shell=True)
subprocess.call("salt -C " + args.ip_addr + " state.apply performance", shell=True)
subprocess.call("salt -C " + args.ip_addr + " state.apply node.jsbench.ebbrt", shell=True)
for i in range(0,100):
    out = os.open(str(i) + ".out", os.O_RDWR | os.O_CREAT)
    err = os.open(str(i) + ".err", os.O_RDWR | os.O_CREAT)
    p = subprocess.Popen("salt -C " + args.ip_addr + " state.apply node.jsbench.ebbrt.start", shell=True, stdout=out, stderr=err)
    p.wait()
    os.close(out)
    os.close(err)

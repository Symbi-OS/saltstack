#!/usr/bin/env python

import subprocess

subprocess.call("/tmp/ebbrt-node/node/node < /tmp/ebbrt-node/scripts/fullbench.js", shell=True)

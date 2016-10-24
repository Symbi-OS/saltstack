#!/usr/bin/env python

import subprocess

p = subprocess.Popen("taskset -c 0 /tmp/ebbrt-node/node/node < /tmp/ebbrt-node/scripts/hello_http.js", shell=True)

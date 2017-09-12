#!/bin/bash

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "sh -c 'killall qemu-system-x86_64'"

exit

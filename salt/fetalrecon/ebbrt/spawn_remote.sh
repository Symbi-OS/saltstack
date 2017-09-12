#!/bin/bash

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $1 $2:spawn.elf32
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $2  "sh -c 'nohup /root/spawn.sh $3 $4 $5 > /dev/null 2>&1 &'"

exit

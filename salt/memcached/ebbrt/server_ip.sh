#!/bin/bash
    grep -s 'Dhcp Complete:'  /tmp/stdout | cut -d ' ' -f3

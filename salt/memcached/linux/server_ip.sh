ip addr | grep 192.168 | head -n 1 | cut -d ' ' -f6 | cut -d '/' -f1

s=${1:-15}
while [ True ]; do clear; salt '*' grains.get role; sleep $s; done

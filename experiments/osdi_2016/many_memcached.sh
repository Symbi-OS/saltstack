#!/bin/bash
set -x

ROOT=role
MCD=$ROOT:server
MAS=$ROOT:master
MIN=$ROOT:minion
MUT="G@$MAS or G@$MIN"
ALL="G@$MAS or G@$MIN or G@$MCD"
TEST=

TARGET=${TARGET:-linux}
echo "Experiment for Memcached ${TARGET}"
date

# Sync all salt state
salt -C "$ALL" saltutil.refresh_pillar 
salt -C "$ALL" saltutil.sync_grains 
/srv/scripts/clear_mine.sh
salt -C "$ALL" pkg.install psmisc refresh=True #install killall
salt -C "$MUT" cmd.run "killall mutilate"
salt -G $MCD cmd.run "killall qemu-system-x86_64"
salt -G $MCD cmd.run "killall memcached"

# Print state
salt -C "$ALL" grains.get $ROOT 
salt -C "$ALL" grains.get virtual 

# Install test applications
salt -C "$MUT" state.apply $TEST mutilate -t 60
salt -G $MCD state.apply $TEST memcached.${TARGET}  -t 600

# Performance 
salt -C "$ALL" state.sls $TEST performance 

# Start memcached server
salt -G $MCD state.apply $TEST memcached.${TARGET}.multistart -t 60 &
echo "Waiting for server to come up.."
sleep 30
salt -C "$ALL" mine.update 

# Start mutilate
sleep 10
salt -G $MIN state.apply $TEST mutilate.start &
sleep 30
salt -G $MAS state.apply $TEST mutilate.multistart -t 6000

# Cleanup
echo "Cleaning up..."
salt -C "$MUT" cmd.run "killall mutilate"
salt -G $MCD cmd.run "killall qemu-system-x86_64"
salt -G $MCD cmd.run "killall memcached"
exit 0

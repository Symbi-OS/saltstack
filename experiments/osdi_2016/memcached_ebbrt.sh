#!/bin/bash
set -x
ROOT=custom:memcached:role
ALL=$ROOT:*
MCD=$ROOT:server
MAS=$ROOT:master
MIN=$ROOT:minion
MUT="G@$MAS or G@$MIN"
TEST=

echo "Warning: this assumes that the role grains have already been set on each node."

# Sync all salt state
salt -G $ALL saltutil.refresh_pillar 
salt -G $ALL saltutil.sync_grains 
/srv/scripts/clear_mine.sh

# Apply performance optimisations
salt -G $ALL state.sls $TEST performance 

# Install applications
salt -C "$MUT" state.apply $TEST mutilate -t 60
salt -G $MCD state.apply $TEST memcached.ebbrt  -t 600

# Start memcached
salt -G $MCD state.apply $TEST memcached.ebbrt.start -t 60 &
echo "Wait 30 for server to come up"
sleep 30
salt -G $ALL mine.update 
# Start minions
sleep 10
salt -G $MIN state.apply $TEST mutilate.start &
sleep 30
salt -G $MAS state.apply $TEST mutilate.start -t 600

exit 0

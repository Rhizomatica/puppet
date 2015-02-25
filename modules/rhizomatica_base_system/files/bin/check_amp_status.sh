#!/bin/bash
# Check for AMP status on each BTS, from BTS1 up to BTS3
RHIZO_SCRIPT="/home/rhizomatica/bin"
. $RHIZO_SCRIPT/vars.sh
for bts in $BTS1 $BTS2 $BTS3; do
    echo "BTS $bts:";
    ssh root@$bts sbts2050-util sbts2050-pwr-status | grep Amp;
done

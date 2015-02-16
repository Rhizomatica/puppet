#!/bin/sh
# Check for AMP status on each BTS, from BTS1 up to BTS10
. ./vars.sh
for bts in $BTS1 $BTS2 $BTS3 $BTS4 $BTS5 $BTS6 $BTS7 $BTS7 $BTS8 $BTS9 $BTS10; do
    echo "BTS $bts:";
    ssh root@$bts sbts2050-util sbts2050-pwr-status | grep Amp;
done

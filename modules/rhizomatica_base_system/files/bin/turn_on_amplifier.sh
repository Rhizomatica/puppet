#!/bin/bash
# Turn on AMP on all BTS, from BTS1 to BTS 10
. ./vars.sh
LOGFILE="/var/log/rhizomatica/monitor_amp.log"

for bts in $BTS1 $BTS2 $BTS3 $BTS4 $BTS5 $BTS6 $BTS7 $BTS7 $BTS8 $BTS9 $BTS10; do
    logc "Turning on AMP on BTS $bts:"
    ssh root@$bts "sbts2050-util sbts2050-pwr-enable 1 1 1";
done

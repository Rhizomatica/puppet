#!/bin/bash
# Get Position from each BTS, from BTS1 up to BTS3
RHIZO_SCRIPT="/home/rhizomatica/bin"
. $RHIZO_SCRIPT/vars.sh
n=0
for bts in "${BTS_MASTER[@]}" ; do
    echo "BTS $bts:";
    let "n++"
    #ssh root@$bts "/etc/init.d/gpsd stop ; sleep 1 ;/etc/init.d/gpsd start; sleep 1"
    TPV="$( ssh root@$bts "gpspipe -w | head -10 | grep TPV" | head -1 )"
    #echo $TPV
    LAT="$( echo $TPV | sed -r 's/.*"lat":([^,]*)\,.*"lon":([^,]*),.*"alt":([^}]*).*/\1/' )"
    LON="$( echo $TPV | sed -r 's/.*"lat":([^,]*)\,.*"lon":([^,]*),.*"alt":([^}]*).*/\2/' )"
    ALT="$( echo $TPV | sed -r 's/.*"lat":([^,]*)\,.*"lon":([^,]*),.*"alt":([^}]*).*/\3/' )"
    eval LAT_$n=$LAT
    eval LON_$n=$LON
    eval ALT_$n=$ALT
    echo $LAT $LON $ALT
done


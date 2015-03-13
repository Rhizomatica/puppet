#!/bin/bash

LOGFILE="/var/log/monitor_rapi.log"

function logc() {
        txt=$1
        echo "[`date '+%d-%m-%Y %H:%M:%S'`] $txt" >> $LOGFILE
}

curl --connect-timeout 180 --max-time 180  -X GET http://localhost:8085/configuration/site 2>/dev/null
if [ $? -gt 0 ]; then
        logc "RAPI is not responding kill the process"
        PID=`ps axf | grep rapi | grep python | awk '{print $1}'`
        kill -9 $PID
        logc "RAPI restarted"
fi

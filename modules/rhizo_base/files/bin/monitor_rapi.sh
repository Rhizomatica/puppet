#!/bin/bash
RHIZO_SCRIPT="/home/rhizomatica/bin"
. $RHIZO_SCRIPT/vars.sh

LOGFILE="/var/log/monitor_rapi.log"

curl --connect-timeout 180 --max-time 180  -X GET http://localhost:8085/configuration/site 2>/dev/null
if [ $? -gt 0 ]; then
        logc "RAPI is not responding kill the process"
        PID=`ps axf | grep rapi | grep python | awk '{print $1}'`
        kill -9 $PID
        logc "RAPI restarted"
fi

#!/bin/bash
RHIZO_SCRIPT="/home/rhizomatica/bin"
. $RHIZO_SCRIPT/vars.sh
LOGFILE="/var/log/monitor_amp.log"

$RHIZO_SCRIPT/check_amp_status.sh | grep -q OFF
if [ $? == 0 ]; then
        logc "Amplifier is OFF! Turn on amp"
        $RHIZO_SCRIPT/turn_on_amplifier.sh >/dev/null 2>&1
        logc 'Procedure completed'
fi

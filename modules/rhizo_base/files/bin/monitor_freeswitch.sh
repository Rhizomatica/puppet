#!/bin/bash
#Check status of FreeSWITCH SIP interfaces
#Doesn't restart FreeSWITCH if WAN or VPN interfaces are down

RHIZO_SCRIPT="/home/rhizomatica/bin"
. $RHIZO_SCRIPT/vars.sh

LOGFILE="/var/log/monitor_fs.log"

FS_STATUS=`fs_cli -x "sofia status"`

#if !(echo $FS_STATUS | grep -q "external::provider") && (ping -qc 5 8.8.8.8 > /dev/null); then
#	logc "Missing external provider! Restarting FreeSWITCH";
#	sv restart freeswitch;
#fi

if !(echo $FS_STATUS | grep -q "internalvpn") && (ping -qc 5 10.23.0.2); then
	logc "Missing internal VPN. Restarting FreeSWITCH profile";
	fs_cli -x "sofia profile internalvpn restart"
fi

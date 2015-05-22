#!/bin/bash
#Check status of FreeSWITCH SIP interfaces
#Doesn't restart FreeSWITCH if WAN or VPN interfaces are down

FS_STATUS=`fs_cli -x "sofia status"`

if !(echo $FS_STATUS | grep -q "external::provider") && (ping -qc 5 8.8.8.8 > /dev/null); then
	echo "Missing external provider! Restarting FreeSWITCH";
	sv restart freeswitch;
fi

if !(echo $FS_STATUS | grep -q "internalvpn") && (ping -qc 5 10.23.0.2); then
	echo "Missing internal VPN! Restarting FreeSWITCH";
	sv restart freeswitch;
fi

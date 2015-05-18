#!/bin/bash

currdate=`date`

if (grep 'but not bound for Rx' /var/log/osmo-nitb/current > /dev/null); then
	echo -e "$currdate - OpenBSC lost RX bind" >> /var/log/bind_check.log
	/etc/init.d/kannel restart >/dev/null
	:>/var/log/osmo-nitb/current
	echo -e "$currdate - Restarted kannel and cleared osmo-nitb log" >> /var/log/bind_check.log
else
	echo -e "$currdate - OpenBSC has the RX bind" >> /var/log/bind_check.log
fi

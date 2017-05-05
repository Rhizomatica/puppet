#!/bin/bash
RHIZO_SCRIPT="/home/rhizomatica/bin"
. $RHIZO_SCRIPT/vars.sh
. /etc/profile.d/rccn-functions.sh

LOGFILE="/var/log/dirty.log"

if [ -a /tmp/FS-dirty -o -a /tmp/OSMO-dirty ]; then
        waitfor0calls
        if [ -a /tmp/FS-dirty ] ; then
          logc "Freeswitch is tagged for restart due to RCCN update"
          sv restart freeswitch
          rm /tmp/FS-dirty
          logc "freeswitch restarted"
        fi
        if [ -a /tmp/OSMO-dirty ] ; then
          logc "NITB is tagged for restart due to Puppet update"
          sv restart osmo-nitb
          rm /tmp/OSMO-dirty
          logc "osmo-nitb restarted"
        fi
fi

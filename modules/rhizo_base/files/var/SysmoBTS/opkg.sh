#!/bin/bash

# This script will upgrade osmo-* daemons on the BTS
# Depending on circumstances, this might not be safe.

if [ "$PWD" != "/var/SysmoBTS" ]; then
  OLDPWD=$PWD
  cd /var/SysmoBTS
fi
SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/tmp/known-$RANDOM"
. /home/rhizomatica/bin/vars.sh

for bts in "${!BTS[@]}" ; do

  if [ "$(ssh $SSH_OPTS ${BTS[$bts]} 'grep 201705 /etc/opkg/base-feeds.conf >/dev/null; echo $?')" == "0" ] ; then
    grep OPKG_CREDS base-feeds-nightly.conf > /dev/null
    if [ "$?" == "0" ]; then
      sed -i s/OPKG_CREDS/$OPKG_CREDS/g base-feeds-nightly.conf
    fi
    scp $SSH_OPTS base-feeds-nightly.conf root@${BTS[$bts]}:/etc/opkg/base-feeds.conf
    ssh $SSH_OPTS root@${BTS[$bts]} "opkg update; opkg install osmo-bts osmo-pcu sysmobts-util ntp"
    ssh $SSH_OPTS root@${BTS[$bts]} "systemctl enable osmo-pcu; systemctl start osmo-pcu"

  fi 
  
done

if [ "$OLDPWD" != "" ]; then
  cd $OLDPWD
fi

#!/bin/bash

exec 2> /dev/null

SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
. /home/rhizomatica/bin/vars.sh


for bts in "${!BTS[@]}" ; do

  if [ "$(ssh $SSH_OPTS ${BTS[$bts]} sysmobts-util trx-nr)" == "0" ] ; then
    # Master Verified.
    echo "BTS $bts is a 2050 Master"
  fi

  if [ "$(ssh $SSH_OPTS ${BTS[$bts]} sysmobts-util trx-nr)" == "1" ] ; then
    # Slave Verified.
    echo "BTS $bts is a 2050 Slave"
  fi

done

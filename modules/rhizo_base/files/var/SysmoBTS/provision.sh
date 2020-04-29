#!/bin/bash

# This script will copy files to the 2050 BTS(s) on the site
# running the script more than once should be safe.

if [ "$PWD" != "/var/SysmoBTS" ]; then
  OLDPWD=$PWD
  cd /var/SysmoBTS
fi
SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/tmp/known-$RANDOM"
. /home/rhizomatica/bin/vars.sh

for bts in "${!BTS[@]}" ; do

  scp $SSH_OPTS authorized_keys root@${BTS[$bts]}:/home/root/.ssh/
  scp $SSH_OPTS udhcpc root@${BTS[$bts]}:/etc/default/udhcpc
  ssh $SSH_OPTS root@${BTS[$bts]} "echo 'root:$BTSPASS' | /usr/sbin/chpasswd"
  ssh $SSH_OPTS root@${BTS[$bts]} "date -s '$(date)'"
  ssh $SSH_OPTS root@${BTS[$bts]} "echo nameserver 1.1.1.1 > /etc/resolv.conf; echo nameserver 9.9.9.9 >> /etc/resolv.conf"
  scp $SSH_OPTS osmo-pcu.cfg root@${BTS[$bts]}:/etc/osmocom/osmo-pcu.cfg

  if [ "$(ssh $SSH_OPTS ${BTS[$bts]} sysmobts-util trx-nr)" == "0" ] ; then
    # Master Verified.
    echo "BTS is a 2050 Master"
    ssh $SSH_OPTS root@${BTS[$bts]} "echo '$SITE-Master-$bts' > /etc/hostname"
    scp $SSH_OPTS master/gpsd root@${BTS[$bts]}:/etc/default/gpsd
    scp $SSH_OPTS master/ntp.conf root@${BTS[$bts]}:/etc/ntp.conf
    scp $SSH_OPTS leds.sh root@${BTS[$bts]}:/etc/init.d/leds.sh
    scp $SSH_OPTS led.service root@${BTS[$bts]}:/lib/systemd/system/led.service
    scp $SSH_OPTS osmo-bts.service root@${BTS[$bts]}:/lib/systemd/system/osmo-bts-sysmo.service
    ssh $SSH_OPTS root@${BTS[$bts]} "systemctl enable led.service"
  fi

  if [ "$(ssh $SSH_OPTS ${BTS[$bts]} sysmobts-util trx-nr)" == "1" ] ; then
    # Slave Verified.
    echo "BTS is a 2050 Slave"
    ssh $SSH_OPTS root@${BTS[$bts]} "echo '$SITE-Slave-$bts' > /etc/hostname"
    scp $SSH_OPTS slave/gpsdate root@${BTS[$bts]}:/etc/default/gpsdate
  fi

done

if [ "$OLDPWD" != "" ]; then
  cd $OLDPWD
fi

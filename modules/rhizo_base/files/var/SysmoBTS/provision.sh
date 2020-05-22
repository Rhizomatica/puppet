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
  scp $SSH_OPTS pcu bts root@${BTS[$bts]}:/bin/
  ssh $SSH_OPTS root@${BTS[$bts]} "chmod 750 /bin/pcu /bin/bts"
  ssh $SSH_OPTS root@${BTS[$bts]} "expect -v 2>/dev/null"

  if [ "$?" != "0" ]; then
    ssh $SSH_OPTS root@${BTS[$bts]} "mkdir /tmp/ipk"
    scp $SSH_OPTS *.ipk root@${BTS[$bts]}:/tmp/ipk/
    ssh $SSH_OPTS root@${BTS[$bts]} "opkg install /tmp/ipk/*.ipk"
    ssh $SSH_OPTS root@${BTS[$bts]} "rm -r /tmp/ipk"
  fi

  _modelNR=$(ssh $SSH_OPTS ${BTS[$bts]} sysmobts-util model-nr)

  if [ "$?" == "127" ]; then
    echo "No sysmobts-util?"
    continue
  fi

  _trxNR=$(ssh $SSH_OPTS ${BTS[$bts]} sysmobts-util trx-nr)

  if [ "$?" != "0" ] ; then
    echo "TRX Number?"
    continue
  fi

  if [ "$_modelNR" == "65535" ] && [ "$_trxNR" == "255" ] ; then
    echo "Looks like a SysmoBTS"
    ssh $SSH_OPTS root@${BTS[$bts]} "echo '$SITE-$bts' > /etc/hostname"
    scp $SSH_OPTS master/gpsd root@${BTS[$bts]}:/etc/default/gpsd
    scp $SSH_OPTS master/ntp.conf root@${BTS[$bts]}:/etc/ntp.conf
  fi

  if [ "$_trxNR" == "0" ] ; then
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

  if [ "$_trxNR" == "1" ] ; then
    # Slave Verified.
    echo "BTS is a 2050 Slave"
    ssh $SSH_OPTS root@${BTS[$bts]} "echo '$SITE-Slave-$bts' > /etc/hostname"
    scp $SSH_OPTS slave/gpsdate root@${BTS[$bts]}:/etc/default/gpsdate
  fi

done

if [ "$OLDPWD" != "" ]; then
  cd $OLDPWD
fi

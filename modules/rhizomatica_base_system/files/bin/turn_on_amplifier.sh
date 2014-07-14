#!/bin/bash
. ./vars.sh

echo "Beginning amplifier procedure... brace yourself!"

echo "turning off osmo-nitb and kannel"
sv stop osmo-nitb
/etc/init.d/kannel stop

echo "Rebooting first BTS"
ssh root@$BTS1 "/sbin/reboot"

echo "sleeping 30 seconds..."
sleep 30

echo "turning off the second BTS"
ssh root@$BTS1 "/usr/bin/sbts2050-util sbts2050-pwr-enable 1 0 0"

echo "sleeping 10 seconds..."
sleep 10

echo "turning on the amplifier"
ssh root@$BTS1 "/usr/bin/sbts2050-util sbts2050-pwr-enable 1 0 1"

echo "sleeping 10 seconds..."
sleep 10

echo "turning back on the second BTS"
ssh root@$BTS1 "/usr/bin/sbts2050-util sbts2050-pwr-enable 1 1 1"

echo "turning on osmo-nitb and kannel"
sv start osmo-nitb
sleep 10
/etc/init.d/kannel start

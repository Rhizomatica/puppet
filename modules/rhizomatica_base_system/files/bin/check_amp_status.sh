#!/bin/sh
. ./vars.sh
echo "BTS1: "
ssh root@$BTS1 sbts2050-util sbts2050-pwr-status | grep Amp

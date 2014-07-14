#!/bin/bash
. ./vars.sh

while (true);
do STR=`echo "show lchan" | nc localhost 4242 | grep BROKEN`;

if [ -n "$STR" ];
	then echo `date "+%y%m%d_%H%M"` >> /var/tmp/broken_channels_log.txt;
	STR=`echo "show lchan" | nc localhost 4242`;
	echo -e "Subject:BROKEN Channels\n\nBroken at: `date`\n\n\n$STR" | sendmail $RECIPIENTS
fi;
sleep 600;
done

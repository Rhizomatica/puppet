#!/bin/bash

# Control the LED on a SysmoBTS 2050
# We have a Red and a Green LED in one
# Both on = Orange.

_AL=/sys/class/leds/activity_led/
_OL=/sys/class/leds/online_led/
_B=brightness
_T=trigger
_D=delay_on
_DO=delay_off

if [ "$1" == "green" -o "$1" == "g" ]; then
  _L=$_AL
fi

if [ "$1" == "red" -o "$1" == "r" ]; then
  _L=$_OL
fi

if [ "$1" == "reset" ]; then
  echo 0 > $_AL$_B
  echo 0 > $_OL$_B
fi

if [ "$2" == "on" ]; then
  echo 1 > $_L$_B
fi

if [ "$2" == "off" ]; then
  echo 0 > $_L$_B
fi

if [ "$2" == "timer" -o "$2" == "cpu0" ]; then
  echo $2 > $_L$_T
  if [ "$3" == fast ]; then
    echo 50 > $_L$_D
    echo 100 > $_L$_DO
  fi
fi

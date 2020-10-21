#!/bin/sh
#enable Scroll Lock keyboard LED toggle?
allowLED="yes" #empty/commented=disabled
enableLED(){  xset  led named "Scroll Lock";}
disableLED(){ xset -led named "Scroll Lock";}
flashLED(){
 if [ "$allowLED" = "yes" ];then
  for i in $(seq 3);do #10 flashes
   enableLED
   #each time led on for x seconds
   sleep 0.5
   disableLED
   #need to see it's off too
   sleep 0.5
   #echo "cycle $i"
  done
 fi
}



file="$1"
if [ ! "$file" ];then
 echo "no file to monitor given"
 exit 1
fi

monitor_command(){
if [ "$monitor_command" ];then
 "$monitor_command" "$@"
else
 flashLED
fi
}
monitor(){
  {
  echo "monitoring $file" >&2
  a="$(stat -c %Y "$file")" #base modification time (epoch)
  while true;do
   b="$(stat -c %Y "$file")" #get new "last modified" time
   if [ "$a" = "$b" -a "$b" != "" ];then #time unchanged & != null
    true #no-op, could also negate the tests and skip it
   else
    a="$b" #update the base modification time
    printf "%s\t%s\n" "$file" "$(date +"%Y-%m-%d_%T")"
    monitor_command "$monitor_command_args"
   fi
   sleep 2
  done
  }&
  export pid="$pid $!"
}
#TODO: make a fallback between getopt and getopts
#. ./getopt.sh
. ./getopts.sh
#or getopt, if you don't have getopts for some reason
#exec_getopt "$@"
exec_getopts "$@"
#echo "$pid"

while read i;do case "$i" in ("q"*|"Q"*) echo "kill$pid";kill $pid;break;;esac;done

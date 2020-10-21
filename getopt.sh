#!/bin/sh
#getopt is available in busybox
exec_getopt(){
#set GETOPT to use alternative getopt, such as busybox's
getopt="${GETOPT:-getopt}"
O="$(getopt c:f: "$@")"
eval set -- "$O"
while true;do
 case "$1" in
  (-c)   command="$2";shift 2;;
  (-f)   file="$2";"$command" "$file";shift 2;;
  ("--") break;;
  (*)    echo "ERR, $@";break;;
 esac
done
}

#!/bin/bash
# Docker Env Check

ACMD="$1"
ARGV="$@"
ANUM="$#"
ERROR=0

if [ "x$ARGV" = "x" ] ; then
    ARGV="-h"
fi

case $ACMD in
check)
    echo -e "\e[1;31m[kernal] -- require linux 3.8 or high verison\e[0m"
    uname -a
    echo -e "\e[1;31m[cpu] -- 64bit cpu\e[0m"
    lscpu
    echo -e "\e[1;31m[device-mapper] -- Device Manager(default)/AUFS/vfs/btrfs\e[0m"
    if [ -L /sys/class/misc/device-mapper ]; then
        ls -l /sys/class/misc/device-mapper
        result=`grep device-mapper /proc/devices`
        echo $result in /proc/devices
    else
        modprobe dm-mod
        echo add device-mapper module into kernal
    fi
    ERROR=$?
    ;;
startssl|sslstart|start-SSL)
    echo The startssl option is no longer supported.
    echo Please edit httpd.conf to include the SSL configuration settings
    echo and then use "apachectl start".
    ERROR=2
    ;;
configtest)
    $HTTPD -t
    ERROR=$?
    ;;
status)
    $LYNX $STATUSURL | awk ' /process$/ { print; exit } { print } '
    ;;
fullstatus)
    $LYNX $STATUSURL
    ;;
*)
    $HTTPD "$@"
    ERROR=$?
esac

exit $ERROR


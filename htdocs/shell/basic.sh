#!/bin/bash
set -e

ACMD="$1"
ARGV="$@"
ANUM="$#"
ERROR=0

command_exists() {
    command -v "$@" > /dev/null 2>&1
}

if [ "x$ARGV" = "x" ] ; then
    ARGV="-h"
fi

case $ACMD in
kernal)
    kernal_info=`uname -a`
    if command_exists lsb_release; then
        dist_info="$(lsb_release -a 2>/dev/null)"
    fi
    echo -e "\e[1;31m KERNAL: \e[0m"
    echo -e "$kernal_info\n$dist_info" | awk '{ print "\t"$0 }'
    ERROR=$?
    ;;
date)
    now_time=`date +"%Y-%m-%d %H:%M:%S.%N %p %A %B %j %W %Z %z %s"`
    echo -e "\e[1;31m DATE: \e[0m"
    echo -e "\t$now_time"
    if [[ -n $2 ]]; then
        str2int(){ date -d "$1" +%s 2>/dev/null; }
        int2str(){ date -d @"$1" +"%Y-%m-%d %T" 2>/dev/null; }
        str_rawtime=`str2int "$2"`
        str_fmttime=`int2str "$str_rawtime"`
        int_fmttime=`int2str "$2"`
        int_rawtime=`str2int "$int_fmttime"`
        if [[ -n $str_fmttime ]] && [[ -n $str_rawtime ]]; then
            echo -e "\t$str_fmttime --> $str_rawtime"
        fi
        if [[ -n $int_fmttime ]] && [[ -n $int_rawtime ]]; then
            echo -e "\t$int_fmttime <-- $int_rawtime"
        fi
    fi
    ERROR=$?
    ;;
host)
    cpu=`lscpu`
    mem=`free -mh`
    blk=`lsblk`
    df=`df -h`
    echo -e "\e[1;31m HOST: \e[0m"
    echo -e "\e[1;35m \t[cpu] \e[0m"
    echo -e "$cpu" | awk '{ print "\t"$0 }'
    echo -e "\e[1;35m \t[memory] \e[0m"
    echo -e "$mem" | awk '{ print "\t"$0 }'
    echo -e "\e[1;35m \t[block device] \e[0m"
    echo -e "$blk" | awk '{ print "\t"$0 }'
    ERROR=$?
    ;;
startssl|sslstart|start-SSL)
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


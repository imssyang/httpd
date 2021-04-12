#!/bin/bash

APP=httpd
HOME=/opt/$APP
SYSD=/etc/systemd/system
SERFILE=httpd.service

init() {
  if [[ ! -d $HOME/logs ]]; then
    mkdir $HOME/logs
    chmod 755 $HOME/logs
  fi

  if [[ ! -s $SYSD/$SERFILE ]]; then
    ln -s $HOME/setup/$SERFILE $SYSD/$SERFILE
    echo "($APP) create symlink: $SYSD/$SERFILE --> $HOME/setup/$SERFILE"
  fi
}

deinit() {
  if [[ -s $SYSD/$SERFILE ]]; then
    rm -rf $SYSD/$SERFILE
    echo "($APP) delete symlink: $SYSD/$SERFILE"
  fi
}

start() {
  pgrep -x $APP >/dev/null
  if [[ $? != 0 ]]; then
	systemctl start $SERFILE
    echo "($APP) $APP start!"
  fi
  show
}

stop() {
  pgrep -x $APP >/dev/null
  if [[ $? == 0 ]]; then
    systemctl stop $SERFILE
    echo "($APP) $APP stop!"
  fi
  show
}

show() {
  ps -ef | grep $APP | grep -v 'grep'
}

case "$1" in
  init) init ;;
  deinit) deinit ;;
  start) start ;;
  stop) stop ;;
  show) show ;;
  *) SCRIPTNAME="${0##*/}"
     echo "Usage: $SCRIPTNAME {init|deinit|start|stop|show}"
     exit 3
     ;;
esac

exit 0

# vim: syntax=sh ts=4 sw=4 sts=4 sr noet

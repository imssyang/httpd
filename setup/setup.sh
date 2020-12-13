#!/bin/bash

APP=httpd
HOME=/opt/$APP
SYSD=/etc/systemd/system
SERFILE=httpd.service

initialize() {
  if [[ ! -s $SYSD/$SERFILE ]]; then
    ln -s $HOME/setup/$SERFILE $SYSD/$SERFILE
    echo "($APP) create symlink: $SYSD/$SERFILE --> $HOME/setup/$SERFILE"
  fi
}

deinitialize() {
  if [[ -s $SYSD/$SERFILE ]]; then
    rm -rf $SYSD/$SERFILE
    echo "($APP) delete symlink: $SYSD/$SERFILE"
  fi
}

daemon_start() {
  pgrep -x $APP >/dev/null
  if [[ $? != 0 ]]; then
	systemctl start $SERFILE
    echo "($APP) $APP start!"
  fi
  daemon_show
}

daemon_stop() {
  pgrep -x $APP >/dev/null
  if [[ $? == 0 ]]; then
    systemctl stop $SERFILE
    echo "($APP) $APP stop!"
  fi
  daemon_show
}

daemon_show() {
  ps -ef | grep $APP | grep -v 'grep'
}

case "$1" in
  init)
    initialize
    ;;
  deinit)
    deinitialize
    ;;
  start)
    daemon_start
    ;;
  stop)
    daemon_stop
    ;;
  show)
	daemon_show
	;;
  *)
    SCRIPTNAME="${0##*/}"
    echo "Usage: $SCRIPTNAME {init|deinit|start|stop|show}"
    exit 3
    ;;
esac

exit 0

# vim: syntax=sh ts=4 sw=4 sts=4 sr noet

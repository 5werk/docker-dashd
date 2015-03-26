#!/bin/bash
set -e

DASH_PATH="/var/dash"
SERVER_NAME="dash-server"
docker=$(which docker)

uninstall() {
  $docker stop $SERVER_NAME
  $docker rm $SERVER_NAME
  $docker rmi 5werk/dashd
}

install() {
  if [ -z "$1" ]; then
    echo "ERROR: please specify version to install"
    exit 1
  fi
  if [ ! -d $DASH_PATH ]; then
    echo "ERROR: $DASH_PATH does not exist"
    exit 1
  fi
  $docker pull 5werk/dashd:"$1"
  chown -fR 1234:1234 $DASH_PATH
  run "5werk/dashd:$1"
}

run() {
  $docker run -d -v $DASH_PATH:/dash -p 0.0.0.0:9999:9999 --name $SERVER_NAME "$1"
}

try() {
  set +e
  "$1" 2> /dev/null
  set -e
}

case "$1" in
  install)
    try uninstall
    install latest
    ;;
  install-version)
    try uninstall
    install "$2"
    ;;
  upgrade)
    uninstall
    install latest
    ;;
  uninstall)
    uninstall
    ;;
  *)
    echo "ERROR: unknown argument"
    exit 1
    ;;
esac
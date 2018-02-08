#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

cd /built_app

mkdir -p /logs

/opt/nodejs/bin/forever    \
  -a                       \
  -l /logs/forever.log     \
  -o /logs/out.log         \
  -e /logs/forever.error   \
  main.js

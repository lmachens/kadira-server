#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

#Main settings
export MONGO_URL=$APP_MONGO_URL
export MONGO_SHARD_URL_one=$DATA_MONGO_URL
export PORT=$ENGINE_PORT
##Librato settings
#export LIBRATO_EMAIL=$LIBRATO_EMAIL
#export LIBRATO_TOKEN=$LIBRATO_TOKEN
#export LIBRATO_PREFIX=kadira-engine-
#export LIBRATO_INTERVAL=60000


mkdir -p /logs
cd /app

#yarn install

forever    \
  -a                       \
  -l /logs/out.log         \
  -o /logs/out.log         \
  -e /logs/out.log         \
  server.js

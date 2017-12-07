#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

MONGO_URL=$APP_MONGO_URL \
MONGO_SHARD_URL_one=$DATA_MONGO_URL \
PORT=$ENGINE_PORT \
LIBRATO_EMAIL=$LIBRATO_EMAIL \
LIBRATO_TOKEN=$LIBRATO_TOKEN \
LIBRATO_PREFIX=kadira-engine- \
LIBRATO_INTERVAL=60000 \
  node server.js

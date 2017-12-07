#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

STAT_BUILD_INTERVAL=5000 \
MONGO_SHARD_URL_one=$DATA_MONGO_URL \
LIBRATO_EMAIL=$LIBRATO_EMAIL \
LIBRATO_TOKEN=$LIBRATO_TOKEN \
  meteor --port 5005

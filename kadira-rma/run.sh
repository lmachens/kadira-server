#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

MONGO_SHARD=one \
MONGO_URL=$DATA_MONGO_URL \
  npm start

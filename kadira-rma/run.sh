#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

#Main settings
export MONGO_SHARD=one
export MONGO_URL=$DATA_MONGO_URL

mkdir -p /logs
cd /app

#yarn install
yarn start

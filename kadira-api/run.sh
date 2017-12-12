#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

#Main settings
export MONGO_APP_URL=$APP_MONGO_URL
export MONGO_SHARD_URL_one=$DATA_MONGO_URL
export PORT=$PORT
export MAIL_URL=$MAIL_URL

#=====
export JWT_SECRET="jwt-secret"
export JWT_LIFETIME="1d"
export AUTH_SECRET="secret"
export NODE_ENV=production


mkdir -p /logs
cd /app

#yarn install

forever           \
 -a               \
 -l /logs/out.log \
 -o /logs/out.log \
 -e /logs/out.log \
 server.js

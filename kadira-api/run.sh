#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

MONGO_APP_URL=$APP_MONGO_URL \
MONGO_SHARD_URL_one=$DATA_MONGO_URL \
MAIL_URL=$MAIL_URL \
JWT_SECRET="jwt-secret" \
JWT_LIFETIME="1d" \
AUTH_SECRET="secret" \
PORT=7007 \
NODE_ENV=production \
  node_modules/.bin/nodemon server.js

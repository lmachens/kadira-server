#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

#Main settings
export APP_DB_URL=$APP_MONGO_URL
export APP_DB_OPLOG_URL=$APP_MONGO_OPLOG_URL
export MAIL_URL=$MAIL_URL

##Other settings
#export LIBRATO_EMAIL=$LIBRATO_EMAIL
#export LIBRATO_TOKEN=$LIBRATO_TOKEN
#export LIBRATO_METRICS_PREFIX=alertsman.
export TICK_TRIGGER_INTERVAL=10000
export MESSENGER_LOGGING_ONLY=1
export KADIRA_API_URL=http://root:secret@localhost:$API_PORT/core
export NODE_ENV=production

mkdir -p /logs
cd /app

#yarn install

forever    \
  -a                       \
  -l /logs/out.log         \
  -o /logs/out.log         \
  -e /logs/out.log         \
  server.js

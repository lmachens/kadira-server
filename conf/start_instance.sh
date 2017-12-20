#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

if [[ $ROLE"" ]] ; then
  knotable_config=/conf/$DOMAIN_LONG-$ROLE.json
else
  knotable_config=/conf/$DOMAIN_LONG.json
fi

#settings consumed by node.js and meteor
export MONGO_URL='mongodb://kadira.knotel.internal/kadira-app?replicaSet=kadira'
export MONGO_OPLOG_URL='mongodb://kadira.knotel.internal/local?replicaSet=kadira'
export MAIL_URL='smtp://kadira%40knotelmail.com:3xuGEfAX^3xBuKKzMkpVip{NXGs6Xj@smtp.mailgun.org:587'
export ENGINE_PORT=11011
export API_PORT=7007
export ROOT_URL='https://'$HOSTNAME
export PORT=3000

cd /built_app

mkdir -p /logs

/opt/nodejs/bin/forever    \
  -a                       \
  -l /logs/forever.log     \
  -o /logs/out.log         \
  -e /logs/forever.error   \
  main.js

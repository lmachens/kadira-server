#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

export METEOR_ALLOW_SUPERUSER=1
export YARN_CACHE_FOLDER=/yarn_cache
export USER=root
echo "unsafe-perm = true" > /root/.npmrc

cd /app
rm -rf /app/.meteor/local
yarn --prefer-offline --emoji --non-interactive
meteor build --directory /tmp/the-app
mv /tmp/the-app/bundle /built_app
cd /built_app/bundle/programs/server/
yarn --prefer-offline --emoji --non-interactive
chmod -R 777 /built_app
rm -rf /tmp/the-app
rm -rf /app/node_modules

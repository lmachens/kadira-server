#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

# DB settings
export APP_MONGO_URL="mongodb://app:password@candidate.53.mongolayer.com:10478,candidate.54.mongolayer.com:10216/tkadira-app?replicaSet=set-56175e62147ca745d8000761"
export APP_MONGO_OPLOG_URL="mongodb://oplog:password@candidate.53.mongolayer.com:10478,candidate.54.mongolayer.com:10216/local?authSource=tkadira-app&replicaSet=set-56175e62147ca745d8000761"
export DATA_MONGO_URL="mongodb://app:password@candidate.53.mongolayer.com:10478,candidate.54.mongolayer.com:10216/tkadira-data?replicaSet=set-56175e62147ca745d8000761"
export MAIL_URL="smtp://postmaster%40kadira.io:9jx4fqhdfbg5@smtp.mailgun.org:587"

# Engine settings
export ENGINE_PORT=11011

# UI settings
export UI_PORT=4000
export UI_URL="http://localhost:$UI_PORT"

# CPU Profiler needs a s3 bucket
export AWS_DEFAULT_REGION="us-west-2"
# it's better to setup IAM role instead of creds later
#export AWS_ACCESS_KEY_ID="AWSID"
#export AWS_SECRET_ACCESS_KEY="AWSKEY"

# Monitoring Setup

export LIBRATO_EMAIL
export LIBRATO_TOKEN

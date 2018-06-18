#!/usr/bin/env bash
declare -a servers=(
  "apm.mydomain.com"
)

key='~/.ssh/key.pem'
dockerImageName=knotel/meteor-apm-server

#settings consumed by node.js and meteor (example)
MONGO_URL='mongodb://apm.db.mydomain.com/apm-app?replicaSet=apmRS'
MONGO_OPLOG_URL='mongodb://apm.db.mydomain.com/local?replicaSet=apmRS'
MAIL_URL='smtp://apm%40mydomainmail.com:mypassword@smtp.mailgun.org:587'
ENGINE_PORT=11011
API_PORT=7007
ROOT_URL='https://'$HOSTNAME
PORT=3000

function launchServiceOnServer {
  echo "
      Launching Meteor APM Server on $1
  "
  ssh -i $key ubuntu@$1 bash -c "        \
    echo 'Logging in...'               ; \
    docker tag $dockerImageName $dockerImageName:old 2>/dev/null ; \
    docker pull $dockerImageName     &&  \
    docker rm -fv apm &>/dev/null  ;  \
    sleep 2                           ;  \
    docker run -d                        \
     --name apm                       \
     --hostname $1                       \
     -p 3000:3000                        \
     -p 11011:11011                      \
     -p 7007:7007                        \
     -v /knotel/apm:/logs             \
     -e MONGO_URL=$MONGO_URL             \
     -e MONGO_OPLOG_URL=$MONGO_OPLOG_URL \
     -e MAIL_URL=$MAIL_URL               \
     -e ENGINE_PORT=$ENGINE_PORT         \
     -e API_PORT=$API_PORT               \
     -e ROOT_URL=$ROOT_URL               \
     -e PORT=$PORT                       \
    $dockerImageName                  && \
    docker rmi $dockerImageName:old 2>/dev/null"
}

for server in "${servers[@]}"
do
  launchServiceOnServer "$server"
done

echo "RUN TIME: $(($SECONDS / 60))m $(($SECONDS % 60))s"

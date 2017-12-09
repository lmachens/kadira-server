#!/usr/bin/env bash
declare -a servers=(
  "kadira.knotel.com"
)

cd ~/.ssh
key=master-knotel.com.pem
APP_DB='mongodb://kadira.knotel.internal/kadira-app?replicaSet=kadira'
DATA_DB='mongodb://kadira.knotel.internal/kadira-data?replicaSet=kadira'
MAIL_URL="smtp://user:pass@smtp.mailgun.org:587"
ENGINE_PORT=11011
API_PORT=7007

function launchServiceOnServer {
  echo "
      Launching Kadira on $1
  "
  ssh -i $key ubuntu@$1 bash -c " \
    echo 'Logging in...'        ; \
    docker login -u knotable -p d0ckerP^55 registry.knotable.com:443 && \
    docker tag registry.knotable.com:443/knotel-kadira-engine           \
    registry.knotable.com:443/knotel-kadira-engine:old 2>/dev/null    ; \
    docker pull registry.knotable.com:443/knotel-kadira-engine       && \
    docker rm -fv kadira-engine &>/dev/null                           ; \
    sleep 2                       ; \
    docker run -d                   \
     --name kadira-engine           \
     --hostname $1                  \
     -p 11011:11011                 \
     -e APP_MONGO_URL=$APP_DB       \
     -e DATA_MONGO_URL=$DATA_DB     \
     -e ENGINE_PORT=$ENGINE_PORT    \
     -v /knotel/kadira/engine:/logs \
    registry.knotable.com:443/knotel-kadira-engine ; \
    docker rmi registry.knotable.com:443/knotel-kadira-engine:old 2>/dev/null ; \
    \
    \
    docker tag registry.knotable.com:443/knotel-kadira-rma              \
    registry.knotable.com:443/knotel-kadira-rma:old 2>/dev/null       ; \
    docker pull registry.knotable.com:443/knotel-kadira-rma          && \
    docker rm -fv kadira-rma &>/dev/null                              ; \
    sleep 2                       ; \
    docker run -d                   \
     --name kadira-rma              \
     --hostname $1                  \
     -e DATA_MONGO_URL=$DATA_DB     \
     -v /knotel/kadira/rma:/logs    \
    registry.knotable.com:443/knotel-kadira-rma ; \
    docker rmi registry.knotable.com:443/knotel-kadira-rma:old 2>/dev/null ; \
    \
    \
    docker tag registry.knotable.com:443/knotel-kadira-api              \
    registry.knotable.com:443/knotel-kadira-api:old 2>/dev/null       ; \
    docker pull registry.knotable.com:443/knotel-kadira-api          && \
    docker rm -fv kadira-api &>/dev/null                              ; \
    sleep 2                       ; \
    docker run -d                   \
     --name kadira-api              \
     --hostname $1                  \
     -p 7007:7007                   \
     -e APP_MONGO_URL=$APP_DB       \
     -e DATA_MONGO_URL=$DATA_DB     \
     -e MAIL_URL=$MAIL_URL          \
     -e PORT=$API_PORT              \
     -v /knotel/kadira/api:/logs    \
    registry.knotable.com:443/knotel-kadira-api ; \
    docker rmi registry.knotable.com:443/knotel-kadira-api:old 2>/dev/null    
  "
}

for server in "${servers[@]}"
do
  launchServiceOnServer "$server"
done

echo "RUN TIME: $(($SECONDS / 60))m $(($SECONDS % 60))s"

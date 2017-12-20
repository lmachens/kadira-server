#!/usr/bin/env bash
declare -a servers=(
  "kadira.knotel.com"
)

cd ~/.ssh
key=master-knotel.com.pem
dockerImageName=registry.knotable.com:443/knotel-kadira

function launchServiceOnServer {
  echo "
      Launching Kadira on $1
  "
  ssh -i $key ubuntu@$1 bash -c " \
    echo 'Logging in...'        ; \
    docker login -u knotable -p d0ckerP^55 registry.knotable.com:443 && \
    docker tag $dockerImageName $dockerImageName:old 2>/dev/null      ; \
    docker pull $dockerImageName     && \
    docker rm -fv kadira &>/dev/null  ; \
    sleep 2                           ; \
    docker run -d                       \
     --name kadira                      \
     --hostname $1                      \
     -p 3000:3000                       \
     -p 11011:11011                     \
     -p 7007:7007                       \
     -v /knotel/kadira:/logs            \
    $dockerImageName                 && \
    docker rmi $dockerImageName:old 2>/dev/null"
}

for server in "${servers[@]}"
do
  launchServiceOnServer "$server"
done

echo "RUN TIME: $(($SECONDS / 60))m $(($SECONDS % 60))s"

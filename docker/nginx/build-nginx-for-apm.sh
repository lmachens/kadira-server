#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

declare -a images=(
  "knotel/apm-nginx nginx.Dockerfile"
)

################## docker setup ######################
# Smart workdir handling :)
root_directory=`git rev-parse --show-toplevel 2>/dev/null`
if [ -z $root_directory"" ] ; then
  echo -e "\nYou are not in a repo root directory."
  echo -e "Please cd into it and run this script again."
  echo -e "Aborting...\n"
  exit 1
fi

if [ ! `pwd` == $root_directory ] ; then
  echo -e "\nChanging to root directory: $root_directory/docker/nginx"
  cd $root_directory/docker/nginx
fi

# Set up environment for Mac
if [ "$(uname)" == "Darwin" ]; then
  source docker-machine-setup.sh
fi
################## docker setup ######################

function checkRepo {
# Check whether the repo is clean
if [ "`git status -s`" ] ; then
  echo -e "\nThe repository is not clean."
  echo "Please make sure you committed all your changes and run this script again."
  echo -e "Aborting...\n"
  exit 2
fi
}

#checkRepo

#set up sudo for Linux
sudo=sudo
INGROUP=`groups $USER | grep docker`
if [ "$?" != "1" ]; then
  sudo=
elif [ "$(uname)" == "Darwin" ]; then
  sudo=
fi

function buildImage {
  
  if [ -z $2 ]
  then Dockerfile=""
  else Dockerfile="-f $2"
  fi

  echo -e "Checking for existing $1 docker image\n"
  
  IMG=`$sudo docker images |grep $1`
  
  if [ "$?" == "0" ]; then
    echo -e "Setting tag "old" for existing image.\n"
    $sudo docker tag $1 $1-old
  fi
    echo -e "Building new one.\n"
    $sudo docker build -t $1 $Dockerfile .
}

for image in "${images[@]}"
do
  buildImage $image || echo -e "\n\n$(tput setaf 1; tput setab 7)Image building process shows error! Aborting.$(tput sgr 0)\n\n"
  $sudo docker rmi -f $(echo $image | awk '{print $1}')-old &> /dev/null
done

echo -e "\nDONE!\n"
echo "RUN TIME: $(($SECONDS / 60))m $(($SECONDS % 60))s"

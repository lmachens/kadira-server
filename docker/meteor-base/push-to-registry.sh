#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

meteorVersion=1.6.1.1
#meteorVersion=1.5.1
#meteorVersion=1.4.2.3

declare -a images=(
  "knotel/meteord-webapp-buildtime:$meteorVersion"
  "knotel/meteord-webapp-runtime:$meteorVersion"
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
  echo -e "\nChanging to root directory: $root_directory/docker/meteor-base"
  cd $root_directory/docker/meteor-base
fi

# Set up environment for Mac
if [ "$(uname)" == "Darwin" ]; then
	source docker-machine-setup.sh
fi

#set up sudo for Linux
sudo=sudo
INGROUP=`groups $USER | grep docker`
if [ "$?" != "1" ]; then
  sudo=
elif [ "$(uname)" == "Darwin" ]; then
  sudo=
fi


function pushToRegistry {
  echo -e "\n\n\nPushing $1 image...\n"
  $sudo docker push $1
}


for image in "${images[@]}"
do
  pushToRegistry "$image"
done

echo -e "\nDONE!\n"
echo "RUN TIME: $(($SECONDS / 60))m $(($SECONDS % 60))s"

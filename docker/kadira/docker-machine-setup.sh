#!/usr/bin/env bash

# Set up sudo for Linux
export sudo='sudo'
if [ "$(uname)" == "Darwin" ]; then
  export sudo=
fi


# Request docker software installation
if [ ! `which docker-machine` ]  && [ ! `which docker` ] ; then
  if [ "$(uname)" == "Darwin" ]; then
    echo -e "\nPlease download and install either docker-toolbox or docker:\n"
    echo -e "https://docs.docker.com/docker-for-mac/docker-toolbox/\n"
  else
    echo -e "\nPlease install docker:\n"
    echo -e "https://docs.docker.com/engine/installation/linux/ubuntulinux/\n"
  fi
  echo -e "Aborting...\n"
  exit 1
fi


# Set up docker-machine for Mac
if [ `which docker-machine` ] ; then
  # Ensure vm (dev) exist and running
  vm_status=`docker-machine status dev 2>/dev/null`
  if [ $vm_status"" != "Running" ] ; then
    if [ $vm_status"" == "Stopped" ] || [ $vm_status"" == "Saved" ] ; then
      echo "Starting VM - dev"
      docker-machine start dev
    else
      echo "Creating new VM dev"
      docker-machine create --driver virtualbox dev
      if [ `docker-machine status dev`"" != "Running" ] ; then
        echo "docker-machine creation Failed, Aborting..."
        exit 1
      fi
    fi
  fi

  eval "$(docker-machine env dev)"
  export dockerIp=`docker-machine ip dev`
else
  export dockerIp=localhost
fi

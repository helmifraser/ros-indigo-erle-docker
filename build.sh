#!/usr/bin/env bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check args
username=$USER
check=0
if [ "$#" -eq 2 ]; then
  username=$2
  check=1
elif [ "$#" -gt 2 ]||[ "$#" -eq 0 ]; then
  echo "Error:- usage: ./build.sh IMAGE_NAME USER"
  exit 1
fi

echo -e Preparing to build Docker image: ${GREEN}$1${NC}

if [[ $check -eq 1 ]]; then
  echo -e ...with specified username: ${GREEN}$username${NC}
fi

echo -e ${YELLOW}Ensure the above is correct!${NC}
read -p 'Continue? [y/n] ' prompt

if [[ "$prompt" = "n" ]]||[[ "$prompt" = "N" ]]; then
  echo Aborting
  exit 1
fi

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

Build the docker image
docker build\
  --build-arg user=$username\
  --build-arg uid=$UID\
  --build-arg home=$HOME\
  --build-arg workspace=$SCRIPTPATH\
  --build-arg shell=$SHELL\
  -t $1 .

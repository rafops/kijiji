#!/bin/bash

set -Eeuo pipefail

if [ -z "`docker image ls -q kijiji`" ] ; then
  ./build.sh
fi

export KIJIJI_CONFIG_FILE="${1:-config.yml}"

if ! [ -f "./${KIJIJI_CONFIG_FILE}" ]
then
  cp -av ./config.yml.dist ./config.yml
  unset KIJIJI_CONFIG_FILE
fi

docker run -it --rm \
  -e KIJIJI_CONFIG_FILE \
  -v "`pwd`":/root/workdir kijiji
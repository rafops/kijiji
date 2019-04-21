#!/bin/bash

set -Eeuo pipefail

if [ -z "`docker image ls -q kijiji`" ] ; then
  ./build.sh
fi

if ! [ -f "./config.yml" ]
then
  cp -av ./config.yml.dist ./config.yml
fi

docker run -it --rm \
  -v "`pwd`":/root/workdir kijiji
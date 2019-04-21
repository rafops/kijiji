#!/bin/bash

set -Eeuo pipefail

docker run -it --rm \
  -v $(pwd):/root/workdir \
  --entrypoint /usr/local/bin/bundle \
  kijiji "$@"

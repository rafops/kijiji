#!/bin/bash

IFS=";"
while read station line lat lon zip ; do
  echo "================================"
  echo $station
  echo "================================"
  docker run --rm \
    -e PRICE_MIN=1300 \
    -e PRICE_MAX=1700 \
    -e PAGING_MAX=3 \
    -e RADIUS=1.0 \
    -e ADDRESS=$zip \
    -e LATITUDE=$lat \
    -e LONGITUDE=$lon \
    -e REJECT=basement \
    -e REJECT_OLDER_THAN=48 \
    -e ACCEPT="" \
    -v ${PWD}:/root/workdir kijiji
done < subway-stations.csv

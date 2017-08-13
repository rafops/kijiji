#!/bin/bash

feed="feed-`date +%s`.txt"
ruby -Ilib feed.rb > ./feeds/$feed
cat ./feeds/$feed
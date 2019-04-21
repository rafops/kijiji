#!/bin/sh

if ! [ -f "./db/db.sqlite3" ]
then
  ruby -Ilib setup.rb
fi

seed_file="seed-`date +%s`.txt"
ruby -Ilib seed.rb 1>"./seeds/${seed_file}"
cat "./seeds/${seed_file}"
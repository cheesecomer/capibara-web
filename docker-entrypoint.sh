#!/bin/sh

export WORKDIR=$(pwd)
cd /var/capibara

rake assets:precompile --trace
rails db:migrate

cd $WORKDIR
exec "$@"
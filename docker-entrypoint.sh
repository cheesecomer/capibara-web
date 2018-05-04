#!/bin/sh

export WORKDIR=$(pwd)
cd /var/capibara

bundle exec rails db:migrate

cd $WORKDIR
exec "$@"
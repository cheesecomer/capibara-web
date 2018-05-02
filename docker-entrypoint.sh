#!/bin/sh

export WORKDIR=$(pwd)
cd /var/capibara

bundle exec rake assets:precompile
bundle exec rails db:migrate

cd $WORKDIR
exec "$@"
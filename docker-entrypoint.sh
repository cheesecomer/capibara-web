#!/bin/sh

export WORKDIR=$(pwd)
cd /var/capibara

bundle exec rake assets:precompile --trace &>> ./log/production.log
bundle exec rails db:migrate

cd $WORKDIR
exec "$@"
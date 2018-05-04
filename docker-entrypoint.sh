#!/bin/sh

export WORKDIR=$(pwd)
cd /var/capibara

rails db:migrate

cd $WORKDIR
exec "$@"
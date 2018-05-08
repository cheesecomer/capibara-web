#!/bin/sh

export WORKDIR=$(pwd)
cd /var/capibara

rails db:migrate

if [ -n "$SSM_PARAMETER_PREFIX" ]; then
  $(rake ssm:deploy_parameters)
fi

cd $WORKDIR
exec "$@"
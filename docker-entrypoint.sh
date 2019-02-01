#!/bin/sh

export WORKDIR=$(pwd)
cd /var/capibara

if [ -n "$SSM_PARAMETER_PREFIX" ]; then
  $(rake ssm:deploy_parameters)
fi

rails db:migrate

cd $WORKDIR
exec "$@"
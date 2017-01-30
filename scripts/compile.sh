#!/usr/bin/env bash

cd /opt/codedeploy-agent/deployment-root/$DEPLOYMENT_GROUP_ID/$DEPLOYMENT_ID/deployment-archive

# Load the S3 secrets file contents into the environment variables
aws s3 cp s3://deeplock-app-$DEPLOYMENT_GROUP_NAME-secrets/creds.txt --region eu-west-1 creds.txt
eval $(cat creds.txt | sed 's/^/export /')
rm creds.txt

mix local.hex --force
mix local.rebar --force
mix deps.get
npm install
./node_modules/brunch/bin/brunch build --production
mix phoenix.digest
mix release --env=prod
echo $?
mkdir -p /var/app/current
chown owner /var/app/current

VERSION=$(grep version mix.exs | sed 's/^.*version: "//' | sed 's/",//')

cp _build/prod/rel/deeplock_app/releases/$VERSION/deeplock_app.tar.gz /var/app/current/deeplock_app.tar.gz
cd /var/app/current
tar -xzf deeplock_app.tar.gz
chown -R owner ./*

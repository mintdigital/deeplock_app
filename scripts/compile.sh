#!/usr/bin/env bash

cd /opt/codedeploy-agent/deployment-root/$DEPLOYMENT_GROUP_ID/$DEPLOYMENT_ID/deployment-archive

### Update these values for your own S3 bucket ###
SECRETS_S3_BUCKET=webstackwiths3-secretsbucket-1pk4172chs72h
S3_BUCKET_REGION=us-east-1
### Don't update below this line ###

VERSION=$(grep version mix.exs | sed 's/^.*version: "//' | sed 's/",//')
APP_NAME=$(grep app: mix.exs | sed 's/^.*app: ://' | sed 's/,//')

# Load the S3 secrets file contents into the environment variables
aws s3 cp s3://$SECRETS_S3_BUCKET/creds.txt --region $S3_BUCKET_REGION creds.txt
eval $(cat creds.txt | sed 's/^/export /')
rm creds.txt

# Install deps
mix local.hex --force
mix local.rebar --force
mix deps.get
npm install

# Build assets and release
./node_modules/brunch/bin/brunch build --production
MIX_ENV=prod mix phoenix.digest
MIX_ENV=prod mix release --env=prod
echo $?

# Move release into run location, allow execute by owner
mkdir -p /var/app/current
chown owner /var/app/current
cp _build/prod/rel/$APP_NAME/releases/$VERSION/$APP_NAME.tar.gz /var/app/current/$APP_NAME.tar.gz
cd /var/app/current
tar -xzf $APP_NAME.tar.gz
chown -R owner ./*

#!/usr/bin/env bash

. ../env.sh

oc project $CICD_PROJECT

oc new-app -f postgres-persistent-template.yml \
    -p DOMAIN=${DOMAIN} \
    -p APPLICATION_NAME=postgres \
    -p DB_VOLUME_CAPACITY=1Gi \
    -p DATABASE_USER=${DATABASE_USER} \
    -p DATABASE_PASSWORD=${DATABASE_PASSWORD} \
    -p DATABASE_NAME=${DATABASE_NAME} \
    -p DATABASE_ADMIN_PASSWORD=${DATABASE_ADMIN_PASSWORD} \
    -p DATABASE_MAX_CONNECTIONS=100 \
    -p DATABASE_SHARED_BUFFERS=12MB
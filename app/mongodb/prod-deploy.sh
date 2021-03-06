#!/usr/bin/env bash

. ../../mitzicom/env.sh

oc login https://${IP}:8443 -u $USER

oc project ${PROD_PROJECT}

oc new-app -f mongo-statefulset-template.yml \
    -p REPLICAS=3



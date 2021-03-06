#!/usr/bin/env bash

. ../mitzicom/env.sh

oc login https://${IP}:8443 -u $USER

oc project $PROD_PROJECT

oc delete all --all
oc delete configmaps --all
oc delete pvc --all
oc delete secret mongodb


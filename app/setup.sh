#!/usr/bin/env bash

#setup Jenkins Jobs
JENKINS_USER=justin-admin
JENKINS_TOKEN=ef09f2fdff580b687a6a05cad57c9429
JENKINS=jenkins-cicd.apps.ocp.datr.eu

CRUMB_JSON=$(curl -s "https://${JENKINS_USER}:${JENKINS_TOKEN}@${JENKINS}/crumbIssuer/api/json")

echo CRUMB_JSON=$CRUMB_JSON
CRUMB=$(echo $CRUMB_JSON | jq -r .crumb)
echo CRUMB=$CRUMB

curl -v -H "Content-Type: text/xml" \
  --user ${JENKINS_USER}:${JENKINS_TOKEN} \
  -H Jenkins-Crumb:${CRUMB} \
  --data-binary @mlbparks/config.xml \
  -X POST https://${JENKINS}/createItem?name=mlbparks

curl -v -H "Content-Type: text/xml" \
  --user ${JENKINS_USER}:${JENKINS_TOKEN} \
  -H Jenkins-Crumb:${CRUMB} \
  --data-binary @nationalparks/config.xml \
  -X POST https://${JENKINS}/createItem?name=nationalparks

curl -v -H "Content-Type: text/xml" \
  --user ${JENKINS_USER}:${JENKINS_TOKEN} \
  -H Jenkins-Crumb:${CRUMB} \
  --data-binary @parksmap/config.xml \
  -X POST https://${JENKINS}/createItem?name=parksmap


#set up mongo statefulsets
cd mongodb

./dev-deploy.sh
./prod-deploy.sh

cd ..

#set up Opshift resources for use by the microservice components
./build_ocp_resources.sh mlbparks jboss-eap70-openshift:1.6

./build_ocp_resources.sh nationalparks redhat-openjdk18-openshift:1.2

./build_ocp_resources.sh parksmap redhat-openjdk18-openshift:1.2
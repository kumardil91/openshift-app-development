#!/usr/bin/env bash

#. ../env.sh

USER=justindav1s
GOGS=https://gogs-cicd.apps.ocp.datr.eu
TOKEN=a91acd6c02a003988cd526fe3152362b1c2800dc
ORG=mitzicom

curl -v -H "Content-Type: application/json" \
-d '{ "username": "mitzicom", "full_name": "MitziCom", "description": "MitziCom, a telecommunications company", "website": "parksmap-mitzicom-prod.apps.ocp.datr.eu", "location": "USA" }' \
-X POST ${GOGS}/api/v1/admin/users/${USER}/orgs?token=${TOKEN}

curl -H "Content-Type: application/json" \
    -d '{"name": "mlbparks", "description": "mlbparks repo", "private": true, "gitignores": "Java"}' \
    -X POST ${GOGS}/api/v1/org/${ORG}/repos?token=${TOKEN}

curl -H "Content-Type: application/json" \
    -d '{"name": "nationalparks", "description": "nationalparks repo", "private": true, "gitignores": "Java"}' \
    -X POST ${GOGS}/api/v1/org/${ORG}/repos?token=${TOKEN}

curl -H "Content-Type: application/json" \
    -d '{"name": "parksmap", "description": "parksmap repo", "private": true, "gitignores": "Java"}' \
    -X POST ${GOGS}/api/v1/org/${ORG}/repos?token=${TOKEN}


git clone https://github.com/wkulhanek/ParksMap.git pm

git clone ${GOGS}/${ORG}/mlbparks.git
git clone ${GOGS}/${ORG}/nationalparks.git
git clone ${GOGS}/${ORG}/parksmap.git

cp -r pm/mlbparks/* mlbparks
cd mlbparks
sed '5 s/1.0/0.0.1-SNAPSHOT/' pom.xml > pom2.xml && mv pom2.xml pom.xml
cp ../settings.xml .
mkdir config
cp ../../app/mlbparks/config/dev.properties config
cp ../../app/mlbparks/config/prod.properties config
git add *; git commit -m "initial commit"; git push origin master
cd ..

cp -r pm/nationalparks/* nationalparks
cd nationalparks
sed '12 s/1.0/0.0.1-SNAPSHOT/' pom.xml > pom2.xml && mv pom2.xml pom.xml
cp ../settings.xml .
git add *; git commit -m "initial commit"; git push origin master
cd ..

cp -r pm/parksmap/* parksmap
cd parksmap
sed '12 s/1.0/0.0.1-SNAPSHOT/' pom.xml > pom2.xml && mv pom2.xml pom.xml
cp ../settings.xml .
git add *; git commit -m "initial commit"; git push origin master
cd ..

rm -rf pm nationalparks parksmap mlbparks


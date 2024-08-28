#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Please provide a registry and a repo"
  exit
fi

REGISTRY=$1
REPO=$2

docker tag eric-enm-neo4j:standalone $REGISTRY/$REPO/eric-enm-neo4j:standalone
docker tag eric-neo4j-populator:standalone $REGISTRY/$REPO/eric-neo4j-populator:standalone
docker tag eric-neo4j-load-profiles:standalone $REGISTRY/$REPO/eric-neo4j-load-profiles:standalone
docker tag eric-neo4j-load-generator:standalone $REGISTRY/$REPO/eric-neo4j-load-generator:standalone
docker tag eric-load-control-client:standalone $REGISTRY/$REPO/eric-load-control-client:standalone
docker tag eric-load-control-service:standalone $REGISTRY/$REPO/eric-load-control-service:standalone
if [[ "$1" == "local" ]]; then
  echo 'using local repo - no need to push images'
else
  docker push $REGISTRY/$REPO/eric-enm-neo4j:standalone
  docker push $REGISTRY/$REPO/eric-neo4j-populator:standalone
  docker push $REGISTRY/$REPO/eric-load-control-service:standalone
  docker push $REGISTRY/$REPO/eric-neo4j-load-generator:standalone
  docker push $REGISTRY/$REPO/eric-load-control-client:standalone
  docker push $REGISTRY/$REPO/eric-neo4j-load-profiles:standalone
fi
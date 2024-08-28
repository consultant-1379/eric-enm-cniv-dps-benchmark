#!/bin/bash

# A utility script, to be used internally to build the relevant images
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DOCKER_DIR=$SCRIPT_DIR/../docker_cniv

docker build --no-cache -f $DOCKER_DIR/base/Dockerfile -t eric-enm-neo4j:4.4.11-enterprise $DOCKER_DIR/base
docker build --no-cache -f $DOCKER_DIR/neo4j/Dockerfile -t eric-enm-neo4j:4.4.11-enterprise $DOCKER_DIR/neo4j
docker build --no-cache -f $DOCKER_DIR/neo4j-populator/Dockerfile -t eric-neo4j-populator $DOCKER_DIR/neo4j-populator
docker build --no-cache -f $DOCKER_DIR/neo4j-load-profiles/Dockerfile -t eric-neo4j-load-profiles $DOCKER_DIR/neo4j-load-profiles
docker build --no-cache -f $DOCKER_DIR/load-generator/Dockerfile -t eric-neo4j-load-generator $DOCKER_DIR/load-generator
docker build --no-cache -f $DOCKER_DIR/load-control-client/Dockerfile -t eric-load-control-client $DOCKER_DIR/load-control-client
docker build --no-cache -f $DOCKER_DIR/load-control-service/Dockerfile -t eric-load-control-service $DOCKER_DIR/load-control-service

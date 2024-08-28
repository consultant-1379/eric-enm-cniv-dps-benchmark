#!/bin/bash

# A utility script, used to build Docker images for use external to Ericsson - will build for the local environment. 
# This script has no effect when running from AMD64 based systems

docker build --no-cache -f docker/neo4j/Dockerfile -t eric-enm-neo4j:standalone lib
docker build --no-cache -f docker/neo4j-populator/Dockerfile -t eric-neo4j-populator:standalone lib
docker build --no-cache -f docker/neo4j-load-profiles/Dockerfile -t eric-neo4j-load-profiles:standalone docker/neo4j-load-profiles
docker build --no-cache -f docker/load-generator/Dockerfile -t eric-neo4j-load-generator:standalone lib
docker build --no-cache -f docker/load-control-client/Dockerfile -t eric-load-control-client:standalone lib
docker build --no-cache -f docker/load-control-service/Dockerfile -t eric-load-control-service:standalone lib

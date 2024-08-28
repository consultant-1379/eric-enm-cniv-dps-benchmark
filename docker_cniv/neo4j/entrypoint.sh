#!/bin/bash

# Source the environment to use JDK 11.
echo "Sourcing neo4j_env"
source /ericsson/3pp/neo4j/conf/neo4j_env
# The ADP image contains this file which prevents Neo4j to start.
rm -f /ericsson/3pp/neo4j/run
# Copy extensions into the directory configured by the ADP image.
mkdir -p /plugins
cp /ericsson/3pp/neo4j/plugins/neo4j-java-driver-transport-bolt-extension.jar /plugins/
cp /ericsson/3pp/neo4j/plugins/load-testing-control-plugin.jar /plugins/
# Remove the default configuration and generate one based on our configurations defined via environment variables.
echo "Generating neo4j.conf"
rm -f /ericsson/3pp/neo4j/conf/neo4j.conf
/opt/ericsson/neo4j/service/generate_conf.py

echo "Starting Neo4j"
/ericsson/3pp/neo4j/bin/neo4j start
while [ ! -f /data/logs/debug.log ]
do
  echo "Neo4j not started yet, waiting..."
  sleep 5
done
tail -f /data/logs/debug.log

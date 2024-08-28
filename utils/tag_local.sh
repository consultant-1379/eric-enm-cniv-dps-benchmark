#!/bin/bash

docker tag test-eric-enm-neo4j:4.4.11-enterprise local/repo/eric-enm-neo4j:4.4.11-enterprise
docker tag eric-neo4j-populator:latest local/repo/eric-neo4j-populator:latest
docker tag eric-neo4j-load-generator:latest local/repo/eric-neo4j-load-generator:latest
# uncomment here and comment following two lines if you need a local image for profiles and templates
# docker tag eric-neo4j-load-profiles:latest local/repo/eric-neo4j-load-profiles:latest
docker pull armdocker.rnd.ericsson.se/proj-eric-oss-cniv/proj-eric-oss-cniv-drop/eric-neo4j-load-profiles:ENM_23.3_Small_Cloud_Native
docker tag armdocker.rnd.ericsson.se/proj-eric-oss-cniv/proj-eric-oss-cniv-drop/eric-neo4j-load-profiles:ENM_23.3_Small_Cloud_Native local/repo/neo4j-load-profiles:ENM_23.3_Small_Cloud_Native
docker tag eric-load-control-client:latest local/repo/eric-load-control-client:latest
docker tag eric-load-control-service:latest local/repo/eric-load-control-service:latest
docker pull armdocker.rnd.ericsson.se/proj-eric-oss-cniv/proj-eric-oss-cniv-drop/eric-dps-ltf:latest
docker tag armdocker.rnd.ericsson.se/proj-eric-oss-cniv/proj-eric-oss-cniv-drop/eric-dps-ltf:latest local/repo/eric-dps-ltf:latest

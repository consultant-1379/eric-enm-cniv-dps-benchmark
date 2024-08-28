FROM neo4j:4.4-enterprise

ENV NEO4J_ACCEPT_LICENSE_AGREEMENT=yes

COPY neo4j-java-driver-transport-bolt-extension.jar /var/lib/neo4j/plugins/neo4j-java-driver-transport-bolt-extension.jar
COPY load-testing-control-plugin.jar /var/lib/neo4j/plugins/load-testing-control-plugin.jar

# the Neo4j container needs to run as root
# hadolint ignore=DL3002
USER root

EXPOSE 7474 7687 2004

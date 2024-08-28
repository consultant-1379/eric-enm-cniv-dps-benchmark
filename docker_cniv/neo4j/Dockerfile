ARG GRAPHDB_BASE_IMAGE_REPO=armdocker.rnd.ericsson.se/aia_releases
ARG GRAPHDB_BASE_IMAGE_NAME=graphdb-n4j
ARG GRAPHDB_BASE_IMAGE_TAG=0.0.1-340
FROM $GRAPHDB_BASE_IMAGE_REPO/$GRAPHDB_BASE_IMAGE_NAME:$GRAPHDB_BASE_IMAGE_TAG
ARG CREATED
ARG COMMIT
ARG APP_VERSION
# LTF's product number is 'APR 201 973', but the DR checker expects it to begin with CXU or CXC
LABEL com.ericsson.product-number="CXU 101 0001" \
      org.opencontainers.image.title="Load Testing Framework" \
      org.opencontainers.image.created=${CREATED} \
      org.opencontainers.image.revision=${COMMIT} \
      org.opencontainers.image.vendor="Ericsson" \
      org.opencontainers.image.version=${APP_VERSION}
ENV NEO4J_ACCEPT_LICENSE_AGREEMENT=yes
ENV USER_ID=10001
ENV USER_NAME="DPS"
COPY entrypoint.sh /opt/ericsson/neo4j/service/d3/

USER root
RUN zypper install -y "wget>=1.20.3" && zypper clean \
    && wget -q "https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/artifact/maven/redirect?r=releases&g=com.ericsson.oss.itpf.datalayer.dps.3pp&a=neo4j-java-driver-transport-bolt-extension&v=RELEASE&c=shaded" --output-document=/ericsson/3pp/neo4j/plugins/neo4j-java-driver-transport-bolt-extension.jar \
    && wget -q "https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/artifact/maven/redirect?r=releases&g=com.ericsson.oss.itpf.datalayer.dps&a=load-testing-control-plugin&v=RELEASE&c=shaded" --output-document=/ericsson/3pp/neo4j/plugins/load-testing-control-plugin.jar \
    && sed -i 's/\r$//' /opt/ericsson/neo4j/service/d3/entrypoint.sh && chmod u+x /opt/ericsson/neo4j/service/d3/entrypoint.sh \
    && echo "$USER_NAME:x:$USER_ID:$USER_ID::/nonexistent:/bin/false" >>/etc/passwd \
    && echo "$USER_NAME:!:0::::::" >>/etc/shadow \
    && chown "$USER_ID" /opt/ericsson/neo4j/service/d3/entrypoint.sh

RUN chown -R "$USER_ID:$USER_ID" /ericsson/neo4j_data \
    && chown -R "$USER_ID:$USER_ID" /ericsson/3pp/neo4j \
    && chown -R "$USER_ID:$USER_ID" /etc/neo4j \
    && mkdir -p /plugins && chown "$USER_ID" /plugins \
    && mkdir -p /var/run/neo4j && chown "$USER_ID" /var/run/neo4j \
    && chown "$USER_ID:$USER_ID" /opt/ericsson/neo4j/service/generate_conf.py

EXPOSE 7474 7687 2004

USER $USER_ID
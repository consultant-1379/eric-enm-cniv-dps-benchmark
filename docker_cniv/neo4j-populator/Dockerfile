ARG GRAPHDB_BASE_IMAGE_REPO=armdocker.rnd.ericsson.se/aia_releases
ARG GRAPHDB_BASE_IMAGE_NAME=graphdb-n4j
ARG GRAPHDB_BASE_IMAGE_TAG=0.0.1-318

ARG BASE_IMAGE_REPO=armdocker.rnd.ericsson.se/proj-eric-oss-cniv/proj-eric-oss-cniv-ci-internal
ARG BASE_IMAGE_NAME=eric-dps-ltf
ARG BASE_IMAGE_TAG=latest

FROM $GRAPHDB_BASE_IMAGE_REPO/${GRAPHDB_BASE_IMAGE_NAME}:$GRAPHDB_BASE_IMAGE_TAG as graphdb
FROM ${BASE_IMAGE_REPO}/${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}

USER root
COPY --from=graphdb /ericsson/3pp/neo4j/lib /var/lib/neo4j/lib
WORKDIR /populator

RUN mkdir -p ./lib \
    && wget -q "https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/artifact/maven/redirect?r=releases&g=com.ericsson.oss.itpf.datalayer.dps&a=neo4j-data-populator&v=RELEASE&e=tar.gz&c=package" --output-document=package.tar.gz \
    && tar -xzvf package.tar.gz && mv neo4j-data-populator/lib/* ./lib \
    && rm -r neo4j-data-populator && rm package.tar.gz \
    && find /var/lib/neo4j/lib -name '*slf4j*' -delete

RUN mkdir -p /var/lib/neo4j/logs && chown -R "$USER_ID" /var/lib/neo4j
USER $USER_ID
# it is possible to pass commands into shell based entry points even though the docker documentation suggests otherwise
# see https://stackoverflow.com/questions/62944982/can-docker-entrypoint-in-shell-form-use-runtime-command-args
# hadolint ignore=DL3025
ENTRYPOINT exec java $JAVA_OPTS -Dlog.dir=$LOG_DIRECTORY -cp '/populator/lib/*:/var/lib/neo4j/lib/*' com.ericsson.oss.itpf.datalayer.dps.tools.neo4j.data.populator.Neo4jPopulator $0
CMD [ "/var/lib/neo4j" ]

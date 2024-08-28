FROM neo4j:4.4-enterprise as neo4j
FROM openjdk:11-jdk

COPY --from=neo4j /var/lib/neo4j/lib /var/lib/neo4j/lib

# neo4j image has nop versions of slf4j
RUN find /var/lib/neo4j/lib -name 'slf4j*.jar' -delete

WORKDIR /populator

# When building this image, the build context must point to the lib directory
RUN mkdir -p ./lib
ADD neo4j-data-populator.tar.gz .
RUN mv neo4j-data-populator/lib/* ./lib && rm -r neo4j-data-populator

RUN mkdir -p /var/lib/neo4j/logs

# it is possible to pass commands into shell based entry points even though the docker documentation suggests otherwise
# see https://stackoverflow.com/questions/62944982/can-docker-entrypoint-in-shell-form-use-runtime-command-args
# hadolint ignore=DL3025
ENTRYPOINT exec java $JAVA_OPTS -Dlog.dir=$LOG_DIRECTORY -cp '/populator/lib/*:/var/lib/neo4j/lib/*' com.ericsson.oss.itpf.datalayer.dps.tools.neo4j.data.populator.Neo4jPopulator $0
CMD [ "/var/lib/neo4j" ]

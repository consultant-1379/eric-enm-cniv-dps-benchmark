ARG BASE_IMAGE_REPO=armdocker.rnd.ericsson.se/proj-eric-oss-cniv/proj-eric-oss-cniv-ci-internal
ARG BASE_IMAGE_NAME=eric-dps-ltf
ARG BASE_IMAGE_TAG=latest

FROM $BASE_IMAGE_REPO/${BASE_IMAGE_NAME}:$BASE_IMAGE_TAG

USER root
WORKDIR /generator

RUN wget -q "https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/artifact/maven/redirect?r=releases&g=com.ericsson.oss.itpf.datalayer.dps&a=metric-load-generator&v=RELEASE&c=exec" --output-document=metric-load-generator.jar

CMD ["sh", "-c", "exec java $JAVA_OPTS -Dspring.config.location=$CONFIG_FILE_LOCATION -jar metric-load-generator.jar"]

EXPOSE 2004
USER $USER_ID

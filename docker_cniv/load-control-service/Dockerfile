ARG BASE_IMAGE_REPO=armdocker.rnd.ericsson.se/proj-eric-oss-cniv/proj-eric-oss-cniv-ci-internal
ARG BASE_IMAGE_NAME=eric-dps-ltf
ARG BASE_IMAGE_TAG=latest

FROM $BASE_IMAGE_REPO/${BASE_IMAGE_NAME}:$BASE_IMAGE_TAG

USER root
WORKDIR /control

RUN wget -q "https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/artifact/maven/redirect?r=releases&g=com.ericsson.oss.itpf.datalayer.dps&a=load-testing-control-service&v=RELEASE&c=exec" --output-document=load-testing-control-service.jar

USER $USER_ID
CMD ["sh", "-c", "exec java $JAVA_OPTS -Dlog.level=$LOG_LEVEL -Dcniv.enabled=$RUNNING_IN_CNIV -Dspring.config.location=$SPRING_CONFIG -jar load-testing-control-service.jar"]

ARG BASE_IMAGE_REPO=armdocker.rnd.ericsson.se/proj-eric-oss-cniv/proj-eric-oss-cniv-ci-internal
ARG BASE_IMAGE_NAME=eric-dps-ltf
ARG BASE_IMAGE_TAG=latest

FROM ${BASE_IMAGE_REPO}/${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}

USER root
WORKDIR /control

RUN wget -q "https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/artifact/maven/redirect?r=releases&g=com.ericsson.oss.itpf.datalayer.dps&a=load-testing-control-client&v=RELEASE&c=shaded" --output-document=load-testing-control-client.jar

ENTRYPOINT ["java", "-cp",  "load-testing-control-client.jar", "com.ericsson.oss.itpf.datalayer.dps.generator.control.client.ControlRestClient"]

USER $USER_ID
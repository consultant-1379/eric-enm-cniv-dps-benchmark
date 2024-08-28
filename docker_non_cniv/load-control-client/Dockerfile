FROM openjdk:11-jdk

WORKDIR /control

# When building this image, the build context must point to the lib directory
COPY load-testing-control-client.jar ./load-testing-control-client.jar

ENTRYPOINT ["java", "-cp",  "load-testing-control-client.jar", "com.ericsson.oss.itpf.datalayer.dps.generator.control.client.ControlRestClient"]

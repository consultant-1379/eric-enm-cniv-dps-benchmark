FROM openjdk:11-jdk

WORKDIR /generator

# When building this image, the build context must point to the lib directory
COPY metric-load-generator.jar ./metric-load-generator.jar

# hadolint ignore=DL3025
CMD ["sh", "-c", "exec java $JAVA_OPTS -Dspring.config.location=$CONFIG_FILE_LOCATION -jar metric-load-generator.jar"]

EXPOSE 2004

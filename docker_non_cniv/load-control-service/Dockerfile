FROM openjdk:11-jdk

WORKDIR /control

# When building this image, the build context must point to the lib directory
COPY load-testing-control-service.jar ./load-testing-control-service.jar

CMD ["sh", "-c", "exec java $JAVA_OPTS -Dlog.level=$LOG_LEVEL -Dspring.config.location=$SPRING_CONFIG -jar load-testing-control-service.jar"]


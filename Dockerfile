# Forcing platform arm64/v8 to create graviton3 images
FROM --platform=linux/arm64/v8 maven:3.8.6-jdk-8-slim AS build
RUN mkdir -p /workspace
WORKDIR /workspace
COPY pom.xml /workspace
COPY src /workspace/src
RUN mvn -B -f pom.xml clean package -DskipTests

FROM --platform=linux/arm64/v8 arm64v8/openjdk:8u121-alpine

COPY --from=build /workspace/target/jmx2graphite-*-javaagent.jar /jmx2graphite.jar
ADD slf4j-simple-1.7.25.jar /slf4j-simple-1.7.25.jar
ADD application.conf /application.conf
CMD java -cp jmx2graphite.jar:slf4j-simple-1.7.25.jar io.logz.jmx2graphite.Jmx2GraphiteJolokia application.conf 

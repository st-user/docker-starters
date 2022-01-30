FROM maven AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:resolve-plugins dependency:resolve
COPY . .
RUN mvn clean package
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

# FROM openjdk:17-alpine
# Image for arm64 architecture (e.g. Apple M1)
FROM arm64v8/openjdk:17-slim
ARG SPRING_GROUP=springgrp
ARG SPRING_USER=springusr
RUN addgroup --system "${SPRING_GROUP}"
RUN adduser --system "${SPRING_USER}"
RUN addgroup "${SPRING_USER}" "${SPRING_GROUP}"

RUN mkdir -p /var/log/spring && chown "${SPRING_USER}:${SPRING_GROUP}" /var/log/spring

USER "${SPRING_USER}:${SPRING_GROUP}"

COPY --from=build /app/target/dependency/BOOT-INF/lib /app/lib
COPY --from=build /app/target/dependency/META-INF /app/META-INF
COPY --from=build /app/target/dependency/BOOT-INF/classes /app

ENTRYPOINT ["java", "-cp", "app:app/lib/*", "com.example.App"]
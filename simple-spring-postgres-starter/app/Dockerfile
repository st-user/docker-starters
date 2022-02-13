FROM openjdk:17

ARG SPRING_GROUP=springgrp
ARG SPRING_USER=springusr

RUN groupadd "${SPRING_GROUP}"
RUN useradd "${SPRING_USER}" -g "${SPRING_GROUP}"

RUN mkdir -p /var/log/spring && chown "${SPRING_USER}:${SPRING_GROUP}" /var/log/spring

USER "${SPRING_USER}:${SPRING_GROUP}"

ARG DEPENDENCY=target/dependency
COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java", "-cp", "app:app/lib/*", "com.example.App"]
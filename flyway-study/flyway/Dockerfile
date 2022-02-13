FROM ubuntu

WORKDIR /work

RUN mkdir flyway
RUN apt update
RUN apt install -y wget

# Use the one of the distribution without jre
# so that we can use it on both arm architecture and amd architecture.
RUN wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/8.4.4/flyway-commandline-8.4.4.tar.gz \
    | tar xvz && ln -s `pwd`/flyway-8.4.4/flyway /usr/local/bin

RUN apt install -y iputils-ping
RUN apt install -y vim
RUN apt install -y openjdk-17-jdk
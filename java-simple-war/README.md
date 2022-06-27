# java-simple-war

Simple servlet with tomcat container.

## Build & Run


``` bash

./mvnw clean package
docker build -t my-tomcat .

```

```bash

docker run -it -d -p 8080:8080 --name my-tomcat my-tomcat

```


## References

 - [Apache Maven WAR Plugin](https://maven.apache.org/plugins/maven-war-plugin/index.html)
 - [Deploying a Java War in a Docker Container](https://www.baeldung.com/docker-deploy-java-war)
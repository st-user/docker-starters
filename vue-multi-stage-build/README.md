# vue-multi-stage-build

Single page application (SPA) hosted on nginx in docker container.

The SPA is made with Vue.js and built utilizing [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/).


## Build

```
docker build -t my-vue-spa-nginx .

```


## Run

```
docker run -it -d -p 8080:80 --name my-app-container my-vue-spa-nginx
```
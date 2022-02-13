# flyway-study

The project for studying [Flyway](https://flywaydb.org/).

## Create volumes

```
docker volume create flyway-data
docker volume create flyway-postgres-data
```

## Build and run

```

# Build and run
docker compose up -d --build

# Run the container for flyway
docker compose run -d flyway

# Enter the container
docker exec -it ${your_container_name} /bin/bash

```


## flyway.conf example

```

flyway.url=jdbc:postgresql://postgres-db:5432/flywaytestdb
flyway.user=migrationuser
flyway.password=migrationpass
flyway.schemas=flywaytestsch
flyway.defaultSchema=flywaytestsch

```


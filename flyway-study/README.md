# flyway-study

The project for studying [Flyway](https://flywaydb.org/).

## Create volumes

```
docker volume create flyway-data
docker volume create flyway-postgres-data
```


## flyway.conf example

```

flyway.url=jdbc:postgresql://postgres-db:5432/flywaytestdb
flyway.user=migrationuser
flyway.password=migrationpass
flyway.schemas=flywaytestsch
flyway.defaultSchema=flywaytestsch

```


#!/bin/bash

set -e


psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER ${MIGRATION_USER} WITH ENCRYPTED PASSWORD '${MIGRATION_USER_PASSWORD}';
    CREATE DATABASE flywaytestdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'ja_JP.utf8' LC_CTYPE = 'ja_JP.utf8';
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname flywaytestdb <<-EOSQL
    CREATE SCHEMA flywaytestsch;
    GRANT ALL PRIVILEGES ON SCHEMA flywaytestsch TO ${MIGRATION_USER};
EOSQL
#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER repair WITH SUPERUSER PASSWORD 'password';
    CREATE DATABASE testdb WITH OWNER repair;
    CREATE DATABASE integration_db WITH OWNER repair;
EOSQL
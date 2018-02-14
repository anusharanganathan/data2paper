#!/bin/bash

# Wait for postgres to be available
while ! pg_isready -h ${POSTGRES_HOST:-localhost} -p ${POSTGRES_PORT:-5432} > /dev/null 2> /dev/null; do
    echo "Waiting for Postgres server on ${POSTGRES_HOST:-localhost}"
    sleep 2
done
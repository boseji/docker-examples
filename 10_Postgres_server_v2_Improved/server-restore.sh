#!/bin/sh

docker exec -it some-postgres sh -c 'su - postgres -c "psql -f /store/pgBackup postgres"'
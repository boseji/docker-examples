#!/bin/sh

docker exec -it some-postgres sh -c 'su - postgres -c pg_dumpall > /store/pgBackup'
sudo chown $USER pgBackup
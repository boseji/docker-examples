# FIX for User Does not exist Error

Here is the solution to remove the Error
`pg_dumpall: could not connect to database "template1": FATAL:  role "root" does not exist`

Here are Steps

1. First
 
```shell
sudo su - postgres
psql template1
```

This would open the DB `Template1`

**Note:** Some times the above command is not possible. 
.eg. In case of `alpine` based distributions. Then use
```shell
su - postgres
psql template1
``` 

2. Creating role on pgsql with privilege as "superuser"

```sql
CREATE ROLE <username> superuser;
```
.eg. 
```sql
CREATE ROLE demo superuser;
```

This needs to be executed in the `psql` terminal as above.

3. Then create user

```sql
CREATE USER <username>; 
```
eg. 
```sql
CREATE USER demo;
```

This needs to be executed in the `psql` terminal as above.

3. Assign privilege to user

```sql
GRANT ROOT TO <username>;
```

This needs to be executed in the `psql` terminal as above.

4. And then enable login that user, so you can run e.g.: psql template1, from normal $ terminal:

```sql
ALTER ROLE <username> WITH LOGIN;
```

## Backup Commands

Make sure that you are in the admin access for **Postgres** container

```shell
sudo su - postgres
```

or 

```shell
su - postgres
```

Which ever one works or your container.

Next we execute the backup command

```shell
pg_dumpall > /store/pgBackup
```

It would create the Backup file called `pgBackup` inside the `/store` mount point.

## Restore Command

Make sure that you are in the admin access for **Postgres** container

```shell
sudo su - postgres
```

or 

```shell
su - postgres
```

Which ever one works or your container.

Next we execute the restore command

```shell
psql -f /store/pgBackup postgres
```

It would create all the Databases in the backup from `/store/pgBackupDump` file.




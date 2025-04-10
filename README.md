# Fuel50 - Dockerized Flyway Migration
This project provides a containerized setup to run **Flyway database migrations** against a **PostgreSQL** database using **Docker Compose**.
It supports:
-  Clean, fresh installation (for local dev/testing)
-  Schema updates and incremental Flyway migrations without wiping existing data
-  CI/CD-friendly Docker image build & push via GitHub Actions
## Project Structure

```
fuel50/
├── .github/
│   └── workflows/
│       └── docker-image.yml      # GitHub Action to build & push Flyway image to GHCR
├── sql/
│   └── migrations/               # Flyway migration scripts
├── Dockerfile                    # Builds Flyway image with migration scripts
├── docker-compose.yml            # Defines PostgreSQL and Flyway services
├── fresh_install.sh              # Script for a fresh install of the DB and Flyway migrations 
├── update.sh                     # Script for applying incremental Flyway migrations with updated images
└── README.md                     # This file
```

## Prerequisites

Ensure you have installed [Docker Engine](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/) on your machine.

## Usage

### **Fresh Install script**

To start from scratch, including a fresh PostgreSQL database and data:

If you don’t have an SSH key set up for GitHub, use the HTTPS method to clone the repository:
```
git clone https://github.com/lenara122/fuel50.git
```
If you do have an SSH key set up with your GitHub account, you can use the SSH method to clone the repository:
```
git clone git@github.com:lenara122/fuel50.git
```

then run:
```
cd fuel50
./fresh_install.sh
```

For instance if your sql/migrations directory contains:
```
lena@lena:~/assessment/testing2/fuel50/sql/migrations$ ls
V1__schema_init.sql  V2__data_init.sql  V3__schema_add_col.sql  V4__data_add_col.sql  V5__data_add_col.sql
lena@lena:~/assessment/testing2/fuel50/sql/migrations$ 
```
Then Flyway Migration will run all scripts in order after the db service starts.

Current sql migration scripts:
- V1__schema_init.sql      -> creates a table users with id, name columns
- V2__data_init.sql        -> inserts 2 users
- V3__schema_add_col.sql   -> adds 1 new column, called address
- V4__data_add_col.sql     -> updates the address data for existing users
- V5__data_add_col.sql     -> inserts 1 user

To connect to the running database container:
```
lena@lena:~/assessment/testing2/fuel50$ docker exec -ti db psql -U postgres
psql (17.4 (Debian 17.4-1.pgdg120+2))
Type "help" for help.

postgres=# select * from users;
 id |  username  |  name  |  address  
----+------------+--------+-----------
  1 | username_1 | name_1 | address_1
  2 | username_2 | name_2 | address_2
  3 | username_3 | name_3 | address_3
(3 rows)

postgres=# 

```

Logs after running fresh_install.sh:
```
lena@lena:~/assessment/testing2/fuel50$ ./fresh_install.sh 
Stop and remove containers, networks, and volumes
...
Wait for DB to be ready...
Run Flyway migrations using pulled image
Creating fuel50_flyway_run ... done
Flyway OSS Edition 11.7.0 by Redgate

See release notes here: https://rd.gt/416ObMi
Database: jdbc:postgresql://db:5432/postgres (PostgreSQL 17.4)
Schema history table "public"."flyway_schema_history" does not exist yet
Successfully validated 5 migrations (execution time 00:00.038s)
Creating Schema History table "public"."flyway_schema_history" ...
Current version of schema "public": << Empty Schema >>
Migrating schema "public" to version "1 - schema init"
Migrating schema "public" to version "2 - data init"
Migrating schema "public" to version "3 - schema add col"
Migrating schema "public" to version "4 - data add col"
Migrating schema "public" to version "5 - data add col"
Successfully applied 5 migrations to schema "public", now at version v5 (execution time 00:00.026s)
Migration is completed
```
### **Update script**

To pull the latest images and update the database schema and data of your existing installation:
```bash
# Navigate to the directory where you have already cloned the Fuel repository., e.g 
cd ~/fuel50
./update
```
If you've already done a fresh install and manually added a user (e.g., user 4), running ./update.sh will not delete your data. Flyway will only apply new migration scripts that haven’t been executed yet. It tracks migrations using the flyway_schema_history table. So, if you manually added user 4 and someone pushed a migration script to add another user, when you run ./update.sh, your data will persist, and the new user will be added:
```
 id |  username  |  name  |  address  
----+------------+--------+-----------
  1 | username_1 | name_1 | address_1
  2 | username_2 | name_2 | address_2
  3 | username_3 | name_3 | address_3
  4 | username_4 | name_4 | address_4
  5 | username_5 | name_5 | address_5
(7 rows)
```
Logs after running ./update.sh:
```
lena@lena:~/assessment/testing2/fuel50$ ./update.sh 
Stopping and removing containers, but keep data volume
...
Wait for DB to become ready...
Run Flyway migrations (incremental)
Creating fuel50_flyway_run ... done
Flyway OSS Edition 11.7.0 by Redgate

See release notes here: https://rd.gt/416ObMi
Database: jdbc:postgresql://db:5432/postgres (PostgreSQL 17.4)
Successfully validated 6 migrations (execution time 00:00.034s)
Current version of schema "public": 5
Migrating schema "public" to version "6 - data add col"
Successfully applied 1 migration to schema "public", now at version v6 (execution time 00:00.018s)
Update complete. Latest images are running.
Migration is completed
```
### 📝**Note**
Ensure your migration scripts are placed in the sql/migrations directory and follow the Flyway naming conventions (VX__schema_{desc}.sql, VX_data_{desc}.sql, etc.).



# Fuel50 - Dockerized Flyway Migration
This repository contains a set of tools and configurations to manage PostgreSQL database migrations using Flyway, all powered by Docker.
- Docker Compose configuration for running PostgreSQL and Flyway.
- Scripts for fresh installations and updates.
- GitHub Actions CI/CD pipeline for building and pushing Docker images to GitHub Container Registry when migration files are updated
## Directory Structure

```
fuel50/
├── .github/
│   └── workflows/
│       └── docker-image.yml      # GitHub Actions CI/CD configuration
├── data/                         # Directory to store PostgreSQL data (persisted across container restarts)
├── sql/
│   └── migrations/               # SQL migration scripts (V1, V2, etc.)
├── Dockerfile                    # Dockerfile to build the Flyway migration container
├── docker-compose.yml            # Docker Compose configuration for the db(PostgreSQL) and Flyway services
├── fresh_install.sh              # Script for fresh installation/setup
├── update.sh                     # Script for updating the containers and images
└── README.md                     # This file
```

## Prerequisites

Ensure you have installed [Docker Engine](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/) on your machine.

## Usage

### **Fresh Install script**

To start from scratch, including a fresh PostgreSQL database and data:

```bash
git clone git@github.com:lenara122/fuel50.git
cd fuel50
./fresh_install.sh
```

For instance if your sql/migrations directory contains:
```
lena@lena:~/assessment/testing2/fuel50/sql/migrations$ ls
V1__schema_init.sql  V2__data_init.sql  V3__schema_add_col.sql  V4__data_add_col.sql  V5__data_add_col.sql
lena@lena:~/assessment/testing2/fuel50/sql/migrations$ 
```
Then Flyway Migration will run all scripts in order after the db container starts.

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
### **Update script**

To pull the latest images and update the database schema and data of your existing installation:
```bash
# Navigate to the directory where you have already cloned the Fuel repository., e.g cd ~/fuel50
./update
```
Let's say you have already done a fresh install and manually added a user (e.g., user 4), running ./update.sh
will not delete your data. Flyway will only apply new migration scripts that haven’t been executed yet.
It tracks migrations using the flyway_schema_history table. So if i manually added user 4 and somenone pushed a
migration script to add another user, when i run the ./update.sh my data will persist and i will also get the new user:
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
To check the logs of Flyway you can run:
```
lena@lena:~/assessment/testing2/fuel50$ docker-compose logs flyway;
Attaching to flyway_migrations
flyway_migrations | Flyway OSS Edition 11.6.0 by Redgate
flyway_migrations | 
flyway_migrations | See release notes here: https://rd.gt/416ObMi
flyway_migrations | Database: jdbc:postgresql://db:5432/postgres (PostgreSQL 17.4)
flyway_migrations | Successfully validated 6 migrations (execution time 00:00.030s)
flyway_migrations | Current version of schema "public": 5
flyway_migrations | Migrating schema "public" to version "6 - data add col"
flyway_migrations | Successfully applied 1 migration to schema "public", now at version v6 (execution time 00:00.016s)
```
### 📝**Note**
Ensure your migration scripts are placed in the sql/migrations directory and follow the Flyway naming conventions (VX__schema_{desc}.sql, VX_data_{desc}.sql, etc.).



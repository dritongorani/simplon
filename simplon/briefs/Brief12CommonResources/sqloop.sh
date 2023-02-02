#!/bin/bash

echo "Enter database name"

read databaseName

echo "Enter your username"

read username

echo "Enter your password"

read password

echo "Enter your number of databases"

read number



for ((i=1; i<$number + 1; i++))
do
    echo "CREATE DATABASE IF NOT EXISTS ${databaseName}dev${i};" >> example.sql
    echo "CREATE DATABASE IF NOT EXISTS ${databaseName}pro${i};" >> example.sql

    echo "CREATE USER '${username}dev${i}' IDENTIFIED BY '${password}dev${i}';" >> example.sql
    echo "CREATE USER '${username}pro${i}' IDENTIFIED BY '${password}pro${i}';" >> example.sql


    echo "GRANT ALL PRIVILEGES ON ${databaseName}dev${i}.* TO '${username}dev${i}'@'%' IDENTIFIED BY '${password}dev${i}';" >> example.sql
    echo "GRANT ALL PRIVILEGES ON ${databaseName}pro${i}.* TO '${username}pro${i}'@'%' IDENTIFIED BY '${password}pro${i}';" >> example.sql

done

    echo "flush privileges;" >> example.sql

mysql --user=emldataadmin@emlperso --password=Simplon12345. --host=emlperso.mariadb.database.azure.com < example.sql

echo "N'oubliez pas de vous connecter avec votre nom d'utilisateur complet. e.g -u emldataadmin@emlperso"

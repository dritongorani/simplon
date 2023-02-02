#!/bin/bash

# echo "Enter database name"

# read database_name

# echo "Enter your admin_name"

# read admin_name

# echo "Enter your password"

# read password

# echo "Enter your number of databases"

# read number

for ((i=1; i<${number_of_database} + 1; i++))
do
    echo "CREATE DATABASE IF NOT EXISTS ${database_name}dev${i};" >> userdatabases.sql
    echo "CREATE DATABASE IF NOT EXISTS ${database_name}pro${i};" >> userdatabases.sql

    echo "CREATE USER '${admin_name}dev${i}' IDENTIFIED BY '${admin_password}dev${i}';" >> userdatabases.sql
    echo "CREATE USER '${admin_name}pro${i}' IDENTIFIED BY '${admin_password}pro${i}';" >> userdatabases.sql


    echo "GRANT ALL PRIVILEGES ON ${database_name}dev${i}.* TO '${admin_name}dev${i}'@'%' IDENTIFIED BY '${admin_password}dev${i}';" >> userdatabases.sql
    echo "GRANT ALL PRIVILEGES ON ${database_name}pro${i}.* TO '${admin_name}pro${i}'@'%' IDENTIFIED BY '${admin_password}pro${i}';" >> userdatabases.sql

done

    echo "flush privileges;" >> userdatabases.sql

mysql --user=${admin_name}@${server_name} --password=${admin_password} --host=${server_name}.mariadb.database.azure.com < userdatabases.sql

# echo "N'oubliez pas de vous connecter avec votre nom d'utilisateur complet. e.g -u emldataadmin@emlperso"
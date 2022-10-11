#!/bin/bash
#creation fichier instruction sql 
touch instructionsql.sql

#connexion mariadb-client avec password et injection de nos instruction liée a wordpress
#sudo mariadb --user=$ADMIN --password=$ADMINPASS --host=$B12MARIADB < instructionsql.sql > output.tab

nomdb=ccc
echo "Nombre de db"
read nbdb


Create_db (){
	echo $componomdb

    # injection requete creation db et user 
echo "CREATE DATABASE IF NOT EXISTS $componomdb;" >> instructionsql.sql
echo "CREATE USER IF NOT EXISTS $componomuser@$componomdb IDENTIFIED BY '$componomuserpass';" >> instructionsql.sql
echo "GRANT ALL on $componomdb.* to $componomuser@$componomdb identified by '$componomuserpass';" >> instructionsql.sql

}

Nombre_db (){
	f=1
	while [ $f -le $nbdb ]
	do	
		componomdb=$nomdb$f"DEV"
		componomuser=$componomdb"user"
		componomuserpass=$componomuser"pass"
		Create_db
		componomdb=$nomdb$f"PROD"
		componomuser=$componomdb"user"
		componomuserpass=$componomuser"pass"
		Create_db
		f=$((f+1))
	done
}

Sqlfin(){
#finalisation du fichier d'instruction sql
echo "flush privileges;" >> instructionsql.sql
#connexion à mariadb et injection du fichier instruction sql
mariadb --user=acctestun --password=H@Sh1CoR3! --host=alainmariadb.mariadb.database.azure.com < instructionsql.sql > output.tab
}

MAIN(){
	Nombre_db
    Sqlfin
}

MAIN

#bin/bash/

###################################

#Data collection

##################################
data_base_name=
Mariadbpass=Tonytony123456.
Mariadbuser=dritontony
Hostnamewp=
username_wp=wp-admin
password_wp=Driton123456.

#################################


sudo apt update -y

sudo apt upgrade -y


sudo apt install -y apache2 mariadb-client php-mysql php wget


wget -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz


sudo tar -xzvf /tmp/wordpress.tar.gz -C /var/www/html

sudo chown -R www-data.www-data /var/www/html/wordpress

sudo chmod -R 755 /var/www/html/wordpress

sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

sudo chown -R www-data:www-data /var/www/html/wordpress/wp-config.php

sudo service apache2 reload





######################
#Data collection
######################


#echo "Eneter your host url from mariadb?"
#read MariadbHost


#echo "Enter your mariadb username?"
#read Mariadbuser

#echo "Enter your mariadb password?"
#read Mariadbpass




##########################################################



######################################################
cd /var/www/html/wordpress
sudo sed -i "s/database_name_here/$data_base_name/" wp-config.php
sudo sed -i "s/username_here/$Mariadbuser/" wp-config.php
sudo sed -i "s/password_here/$Mariadbpass/" wp-config.php
sudo sed -i "s/localhost/$Hostnamewp/" wp-config.php
#######################################################


###   mysql -h (hostname) -u (username) -p (pass)  ################
###---- Need to create a database for wordpress in mysql if script doesnt do it#####
#!/bin/bash

##mise à jour
sudo apt -y update
sudo apt-get upgrade -y

##installer apache2 et php
sudo apt-get -y install wget apache2
sudo apt-get install php -y

##installer php libs
sudo apt -y install wget php php-cgi php-mysqli php-pear php-mbstring libapache2-mod-php php-common php-phpseclib php-mysql

##installer phpmyadmin
sudo wget -P Downloads https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz ;

##unzip package phpmyadmin
sudo tar xvf Downloads/phpMyAdmin-latest-all-languages.tar.gz phpMyAdmin-5.2.0-all-languages/

##change phpmyadmin directory
sudo mv phpMyAdmin-*/ /usr/share/phpmyadmin

##creer une ficher temporair pour phpmyadmin
sudo mkdir -p /var/lib/phpmyadmin/tmp

##donner les droits au utilisateur web
sudo chown -R www-data:www-data /var/lib/phpmyadmin

## creer un dossier phpmyadmin in etc pour les confs
sudo mkdir /etc/phpmyadmin/


##changer le nom de fichier de confs
sudo cp /usr/share/phpmyadmin/config.sample.inc.php  /usr/share/phpmyadmin/config.inc.php

##on rajoute le lien suivant in the end de dossier
echo "\$cfg['TempDir'] = '/var/lib/phpmyadmin/tmp';" >> /usr/share/phpmyadmin/config.inc.php


#on rajout le fichier suivant pour rajouter les liens suivats
echo "Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php

    <IfModule mod_php5.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>
    <IfModule mod_php.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>

</Directory>

# Authorize for setup
<Directory /usr/share/phpmyadmin/setup>
    <IfModule mod_authz_core.c>
        <IfModule mod_authn_file.c>
            AuthType Basic
            AuthName "phpMyAdminSetup"
            AuthUserFile /etc/phpmyadmin/htpasswd.setup
        </IfModule>
        Require valid-user
    </IfModule>
</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>" >> /etc/apache2/conf-enabled/phpmyadmin.conf

##on restart service apache2
sudo systemctl restart apache2


##############################################
#Installation de wordpress sur debian 11
##############################################

#Install Apache MySQL PHP etc.
sudo apt install apache2 ghostscript libapache2-mod-php mariadb-server php php-bcmath php-curl php-imagick php-intl php-json php-mbstring  php-mysql php-xml php-zip wget

#Download wordpres zipped file
sudo wget https://wordpress.org/latest.tar.gz

#Extract file
sudo tar -xvf latest.tar.gz -C  /root

#Give acces to the file

sudo chown -R www-data: /root

#Add following to the file
#sudo nano /etc/apache2/sites-available/wordpress.conf

echo "<VirtualHost *:80>
        DocumentRoot /root
      <Directory /root>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
      </Directory>
      <Directory /root>
        Options FollowSymLinks
        Require all granted
      </Directory>
</VirtualHost>" >> /etc/apache2/sites-available/wordpress.conf

sudo  mv /root/wordpress/* /root/

#Enable vhost and rewrite
sudo a2ensite wordpress
sudo a2enmod rewrite
sudo a2dissite 000-default
sudo service apache2 reload
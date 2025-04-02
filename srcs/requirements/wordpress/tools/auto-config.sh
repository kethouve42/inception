#!/bin/sh

# // Setup directories for WP
echo "Setting up directories..."
mkdir -p /var/www
mkdir -p /var/www/html
cd /var/www/html

# // Download WP-CLI (WordPress Command Line Interface) and setup an alias
echo "Downloading WP-CLI..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# // Download WordPress
echo "Downloading WordPress..."
wp core download --allow-root


# // Edit config file
echo "Configuring WordPress..."
cp wp-config-sample.php wp-config.php
sed -i -r "s|database_name_here|$MYSQL_DATABASE|1" wp-config.php # // line 23
sed -i -r "s|username_here|$MYSQL_USER|1" wp-config.php # // line 26
sed -i -r "s|password_here|$MYSQL_PASSWORD|1" wp-config.php # // line 29
sed -i -r "s|localhost|mariadb|1" wp-config.php # // line 32
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

# // Install WP and config Admin and User
echo "Installing WordPress..."
wp core install --url=$WP_URL/ --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_MAIL --skip-email --allow-root
wp user create $WP_USER $WP_MAIL --role=author --user_pass=$WP_PASS --allow-root

# // Setup and run PHP
echo "Setting up PHP..."
mkdir -p /run/php
/usr/sbin/php-fpm7.3 -F


#VERSION QUI MARCHE MAIS QUI NE CONFIGURE PAS WORDPRRESS

# #!/bin/sh

# #check if wp-config.php exist
# if [ -f ./wp-config.php ]
# then
# 	echo "wordpress already downloaded"
# else

# ####### MANDATORY PART ##########

# 	#Download wordpress and all config file
# 	wget http://wordpress.org/latest.tar.gz
# 	tar xfz latest.tar.gz
# 	mv wordpress/* .
# 	rm -rf latest.tar.gz
# 	rm -rf wordpress

# 	#Inport env variables in the config file
# 	sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
# 	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
# 	sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
# 	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
# 	cp wp-config-sample.php wp-config.php
# fi

# exec "$@"
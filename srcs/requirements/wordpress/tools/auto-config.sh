#!/bin/sh

# Creation des repertoires pour WP
echo "Setting up directories..."
mkdir -p /var/www
mkdir -p /var/www/html
cd /var/www/html

# Téléchargement de WP-CLI
echo "Downloading WP-CLI..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Téléchargement de WordPress
echo "Downloading WordPress..."
wp core download --allow-root


# Configuration de la base de données
echo "Configuring WordPress..."
cp wp-config-sample.php wp-config.php
sed -i -r "s|database_name_here|$MYSQL_DATABASE|1" wp-config.php
sed -i -r "s|username_here|$MYSQL_USER|1" wp-config.php
sed -i -r "s|password_here|$MYSQL_PASSWORD|1" wp-config.php
sed -i -r "s|localhost|$MYSQL_HOSTNAME|1" wp-config.php
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

# Installation de WordPress
echo "Installing WordPress..."
# Config admin
wp core install --url=$WP_URL/ --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_MAIL --skip-email --allow-root
# config user as author
wp user create $WP_USER $WP_MAIL --role=author --user_pass=$WP_PASS --allow-root
#config user as editor
wp user create $WP_SECOND_USER $WP_MAIL2 --role=subscriber --user_pass=$WP_PASS2 --allow-root

# Lancement de PHP
echo "Setting up PHP..."
mkdir -p /run/php
/usr/sbin/php-fpm7.4 -F
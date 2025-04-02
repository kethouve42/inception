#!/bin/bash

# Vérifier et créer le dossier du socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 777 /run/mysqld

# Initialiser la base de données si elle n'existe pas
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

# Démarrer MariaDB en arrière-plan
mysqld_safe --datadir=/var/lib/mysql &
sleep 5

# Exécuter les commandes MySQL
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Arrêter proprement MariaDB
mysqladmin -u root shutdown

# Relancer MariaDB en mode sécurisé
exec mysqld_safe

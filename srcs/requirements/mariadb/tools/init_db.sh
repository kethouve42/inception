#!/bin/bash

# Démarrer MySQL et attendre qu'il soit prêt
service mysql start
sleep 5

echo "DEBUG: MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD"

# Création de la base de données
echo "Création de la base..."
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

# Création de l'utilisateur
echo "Création de l'utilisateur..."
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# Attribution des privilèges
echo "Attribution des privilèges..."
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"

# Mise à jour de l'utilisateur root
echo "Mise à jour de l'utilisateur root..."
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

# Application des privilèges
echo "FLUSH..."
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Arrêt sécurisé de MySQL
echo "Arrêt de MySQL..."
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Lancement de MySQL en mode sécurisé
exec mysqld_safe
FROM debian:oldstable

# Mise a jour et installation des packages necessaires
RUN apt update -y
RUN apt upgrade -y
RUN apt-get install mariadb-server -y \
	mariadb-client

# Créer le répertoire nécessaire pour le socket Unix
RUN mkdir -p /var/run/mysqld
RUN chown -R mysql:mysql /var/run/mysqld \
	&& chmod 777 /var/run/mysqld

#RUN mkdir -p /etc/mysql/mariadb.conf.d
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/init_db.sh /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/init_db.sh

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint-initdb.d/init_db.sh"]

CMD ["mysqld"]

FROM debian:oldstable

# Mise a jour et installation des packages necessaires
RUN apt update -y
RUN apt upgrade -y
RUN apt install nginx -y

# Creation du certificat SSL auto-signé
RUN mkdir -p etc/nginx/ssl
RUN apt install openssl -y
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=PO/L=PERPIGNAN/O=42/OU=42/CN=kethouve.42.fr/UID=kethouve"


RUN mkdir -p /var/run/nginx

# copie du .conf dans nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

# exposition du port 443
EXPOSE 443

# permission et mise en place du repertoire web
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Commande au lancement de nginx
CMD [ "nginx", "-g", "daemon off;" ]

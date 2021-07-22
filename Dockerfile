# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: pspijkst <pspijkst@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2021/04/10 11:37:12 by pspijkst      #+#    #+#                  #
#    Updated: 2021/04/21 13:53:33 by pspijkst      ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y nginx
RUN apt-get install -y mariadb-server
RUN apt-get install -y php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring php-xml

WORKDIR /var/www/html/

#	phpMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz
RUN tar -xf phpMyAdmin-5.1.0-english.tar.gz && rm phpMyAdmin-5.1.0-english.tar.gz
RUN mv phpMyAdmin-5.1.0-english phpmyadmin

#	Wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xf latest.tar.gz && rm -rf latest.tar.gz

#	Wordpress CLI
#	Get wp-cli, mod to execute and move + rename (for easier calling)
RUN wget https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY ./srcs/index.html /var/www/html
COPY ./srcs/nginx.conf /etc/nginx/sites-available/default
COPY ./srcs/wp-config.php /var/www/html
COPY ./srcs/config.inc.php phpmyadmin
COPY ./srcs/startup.sh startup.sh
COPY ./srcs/config.sh config.sh
COPY ./srcs/services.sh services.sh
COPY ./srcs/autoindex.sh autoindex.sh

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=Codam/CN=localhost" -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt

RUN chown www-data:www-data *
RUN chmod -R 755 /var/www/html/*

CMD bash startup.sh

FROM php:7.1-apache
WORKDIR /var/www/html/
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN a2enmod rewrite
RUN a2enmod headers
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
COPY . .
RUN mkdir "$PWD/tpl_c"
RUN chmod 777 "$PWD/tpl_c" "$PWD/tpl"
RUN mv "$PWD/config/config.dist.php" "$PWD/config/config.php"
EXPOSE 80



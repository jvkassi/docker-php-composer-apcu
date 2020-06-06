# syntax=docker/dockerfile:experimental
FROM composer:latest AS builder

RUN apk add --no-cache $PHPIZE_DEPS
run pecl channel-update pecl.php.net \
    && pecl install apcu \
    && echo "extension=apcu.so" > $PHP_INI_DIR/conf.d/01_apcu.ini
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd
RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    pdo_mysql \
    opcache \
    json \
    mcrypt \
    intl \
    iconv \
    ctype
 
# Install ext-http
RUN pecl install raphf propro
RUN docker-php-ext-enable raphf propro
RUN pecl install pecl_http
RUN echo -e "extension=raphf.so\nextension=propro.so\nextension=http.so" > $PHP_INI_DIR/conf.d/docker-php-ext-http.ini
RUN rm -rf /usr/local/etc/php/conf.d/docker-php-ext-raphf.ini
RUN rm -rf /usr/local/etc/php/conf.d/docker-php-ext-propro.ini
RUN rm -rf /tmp/*

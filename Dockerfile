# syntax=docker/dockerfile:experimental
FROM composer:latest AS builder

RUN apk add --no-cache $PHPIZE_DEPS
run pecl channel-update pecl.php.net \
    && pecl install apcu \
    && echo "extension=apcu.so" > $PHP_INI_DIR/conf.d/01_apcu.ini
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd
RUN docker-php-ext-install -j$(nproc) \
  bcmath bz2 calendar ctype curl dba dom enchant exif ffi fileinfo filter ftp gd gettext gmp hash iconv imap intl json ldap mbstring mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline reflection session shmop simplexml snmp soap sockets sodium spl standard sysvmsg sysvsem sysvshm tidy tokenizer xml xmlreader xmlrpc xmlwriter xsl zend_test zip
 
 
# Install ext-http
RUN pecl install raphf propro
RUN docker-php-ext-enable raphf propro
RUN pecl install pecl_http
RUN echo -e "extension=raphf.so\nextension=propro.so\nextension=http.so" > $PHP_INI_DIR/conf.d/docker-php-ext-http.ini
RUN rm -rf /usr/local/etc/php/conf.d/docker-php-ext-raphf.ini
RUN rm -rf /usr/local/etc/php/conf.d/docker-php-ext-propro.ini
RUN rm -rf /tmp/*

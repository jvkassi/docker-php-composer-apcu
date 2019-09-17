# syntax=docker/dockerfile:experimental
FROM composer:latest AS builder

RUN apk add --no-cache $PHPIZE_DEPS
run pecl channel-update pecl.php.net \
    && pecl install apcu \
    && echo "extension=apcu.so" > $PHP_INI_DIR/conf.d/01_apcu.ini

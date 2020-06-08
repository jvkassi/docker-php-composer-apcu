FROM composer:latest
LABEL maintainer="jeanvincent45@gmail.com"

RUN apk add --no-cache $PHPIZE_DEPS bzip2-dev libcurl curl-dev \ 
    libxml2 libxml2-dev \
    libpng libpng-dev  \  
    libintl gettext-dev \ 
    oniguruma oniguruma-dev \
    gmp-dev \
    freetype-dev libjpeg-turbo-dev libpng-dev \
    libmcrypt-dev \ 
    zip libzip-dev
run pecl channel-update pecl.php.net \
    && pecl install apcu \
    && echo "extension=apcu.so" > $PHP_INI_DIR/conf.d/01_apcu.ini
    
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd 
RUN docker-php-ext-configure zip
RUN docker-php-ext-configure gd 
RUN docker-php-ext-install -j$(nproc) \
  bcmath bz2 gd gettext gmp iconv mbstring sockets xml zip
 
 
# Install ext-http
RUN pecl install raphf propro
RUN docker-php-ext-enable raphf propro
RUN pecl install pecl_http
RUN echo -e "extension=http.so" > $PHP_INI_DIR/conf.d/docker-php-ext-http.ini
RUN rm -rf /tmp/*

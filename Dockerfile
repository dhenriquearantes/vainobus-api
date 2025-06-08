FROM php:8.3-apache

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN apt-get update && apt-get install -y libxml2-dev autoconf automake libpq-dev libonig-dev libzip-dev libcurl4-openssl-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    mysql-common \
    nano \
    libpng-dev \
    librabbitmq-dev \
    libssl-dev \
    && docker-php-ext-install sockets \
    && pecl install amqp \
    && docker-php-ext-enable amqp

RUN docker-php-ext-install intl
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install dom
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pgsql 
RUN docker-php-ext-install pdo_pgsql

RUN docker-php-ext-install curl

RUN docker-php-ext-configure zip \
    && docker-php-ext-install zip

RUN docker-php-ext-install gd
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd

RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

RUN docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN echo "zend_extension = xdebug.so" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.discover_client_host=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "XDEBUG_SESSION=Docker" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.var_display_max_children = 128" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# VIRTUAL-HOST
COPY virtualhost.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite
RUN service apache2 restart

EXPOSE 80
FROM php:7.2-apache-buster
RUN apt-get update \
    && apt-get -y install libzip-dev zlib1g-dev \
    && docker-php-ext-install mysqli pdo pdo_mysql zip opcache pcntl \
    && apt-get -y install curl git \
    && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

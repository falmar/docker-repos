FROM php:7.4-apache-buster
RUN apt-get update \
    && apt-get -y install libzip-dev zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip opcache pcntl \
    && apt-get -y install curl git \
    && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

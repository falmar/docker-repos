FROM php:8.3-fpm-alpine3.19 AS base
RUN apk --no-cache add --virtual .ext-deps freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev libzip-dev libpq-dev icu-dev \
  && apk --no-cache add --virtual .ext-req freetype libjpeg libpng libwebp libzip libpq icu \
  && docker-php-source extract \
  && apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-configure opcache --enable-opcache \
  && docker-php-ext-install gd mysqli pdo pdo_mysql pdo_pgsql zip opcache pcntl intl \
  && pecl install redis apcu \
  && docker-php-ext-enable redis pcntl apcu intl \
  && docker-php-source delete \
  && apk del .ext-deps \
  && pecl clear-cache \
  && apk del .build-deps \
  # composer taken from (https://github.com/geshan/docker-php-composer-alpine)
  && apk --no-cache add curl git \
  && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer


FROM base as dev
RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS linux-headers \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug \
  && docker-php-source delete \
  && apk del .build-deps

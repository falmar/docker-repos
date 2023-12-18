FROM php:8.3-fpm-alpine
RUN apk --no-cache add --virtual .ext-deps libzip-dev libpq-dev \
  && apk --no-cache add --virtual .ext-req libzip libpq \
  && docker-php-source extract \
  && apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && docker-php-ext-configure opcache --enable-opcache \
  && docker-php-ext-install mysqli pdo pdo_mysql pdo_pgsql zip opcache pcntl \
  && pecl install redis apcu \
  && docker-php-ext-enable redis pcntl apcu \
  && docker-php-source delete \
  && apk del .ext-deps \
  && pecl clear-cache \
  && apk del .build-deps \
  # composer taken from (https://github.com/geshan/docker-php-composer-alpine)
  && apk --no-cache add curl git \
  && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

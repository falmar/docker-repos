FROM php:7.4.33-fpm-alpine3.16
RUN apk --no-cache add --virtual .ext-deps freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev libzip-dev \
  && apk --no-cache add --virtual .ext-req freetype libjpeg libpng libwebp libzip \
  && docker-php-source extract \
  && apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install gd mysqli pdo pdo_mysql zip opcache pcntl \
  && pecl install redis \
  && docker-php-ext-enable redis pcntl \
  && pecl install xdebug-3.1.5 \
  # xdebug
  && docker-php-ext-enable xdebug \
  && docker-php-source delete \
  && apk del .ext-deps \
  && apk del .build-deps \
  # composer taken from (https://github.com/geshan/docker-php-composer-alpine)
  && apk --no-cache add curl git \
  && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

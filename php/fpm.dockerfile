ARG BUILDX_PHP_VERSION="8.4"

FROM php:$BUILDX_PHP_VERSION-fpm-alpine AS base

# 1. Install runtime and build deps, PHP extensions (including GD variants)
RUN set -eux \
 && apk --no-cache add --virtual .ext-deps \
      freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev libzip-dev \
      libpq-dev icu-dev \
 && apk --no-cache add --virtual .ext-req \
      freetype libjpeg libpng libwebp libzip libpq icu \
 && apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
 # Extract PHP source for compilation
 && docker-php-source extract \
 # Configure and install complex extensions
 && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
 && docker-php-ext-configure opcache --enable-opcache \
 && docker-php-ext-install gd mysqli pdo pdo_mysql pdo_pgsql zip opcache pcntl intl \
 # Install PECL extensions
 && pecl install redis apcu brotli \
 && docker-php-ext-enable redis apcu brotli \
 # Clean up
 && pecl clear-cache \
 && docker-php-source delete \
 && apk del .build-deps .ext-deps \
 # Install Composer and dev tools
 && apk --no-cache add curl git \
 && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# 2. DEV IMAGE: Adds Xdebug and dev-only deps
FROM base as dev

RUN set -eux \
 && apk --no-cache add --virtual .build-deps $PHPIZE_DEPS linux-headers \
 && pecl install xdebug \
 && docker-php-ext-enable xdebug \
 && pecl clear-cache \
 && docker-php-source delete \
 && apk del .build-deps

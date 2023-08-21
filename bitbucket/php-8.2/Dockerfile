FROM php:8.2-alpine
RUN apk --no-cache add ca-certificates curl git docker-cli-compose docker-cli-buildx \
  && apk --no-cache add --virtual .ext-deps freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev libzip-dev libpq-dev \
  && apk --no-cache add --virtual .ext-req freetype libjpeg libpng libwebp libzip libpq \
  && docker-php-source extract \
  && apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install gd mysqli pdo pdo_mysql pdo_pgsql zip opcache pcntl \
  && pecl install redis \
  && docker-php-ext-enable redis pcntl \
  && docker-php-source delete \
  && apk del .ext-deps \
  && apk del .build-deps \
  # composer taken from (https://github.com/geshan/docker-php-composer-alpine)
  && apk --no-cache add curl git \
  && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

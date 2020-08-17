FROM php:7.2.30-fpm-alpine3.11
RUN apk --no-cache add --virtual .ext-deps freetype-dev libjpeg-turbo-dev libpng-dev postgresql-dev \
  && apk --no-cache add --virtual .ext-req freetype libjpeg libpng libpq \
  && docker-php-source extract \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
                                   --with-png-dir=/usr/include/ \
                                   --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd pdo pdo_pgsql pgsql zip opcache \
  && apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && pecl install redis \
  && docker-php-ext-enable redis \
  && docker-php-source delete \
  && apk del .ext-deps \
  && apk del .build-deps \
  # composer taken from (https://github.com/geshan/docker-php-composer-alpine)
  && apk --no-cache add curl git \
  && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

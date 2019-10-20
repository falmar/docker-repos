FROM php:7.2.23-fpm-alpine3.10
RUN apk --no-cache add --virtual .ext-deps freetype-dev libjpeg-turbo-dev libpng-dev \
  && apk --no-cache add --virtual .ext-req freetype libjpeg libpng \
  && docker-php-source extract \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
                                   --with-png-dir=/usr/include/ \
                                   --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd zip opcache \
  && apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && pecl install redis mongodb \
  && docker-php-ext-enable redis mongodb \
  && docker-php-source delete \
  && apk del .ext-deps \
  && apk del .build-deps \
  # composer taken from (https://github.com/geshan/docker-php-composer-alpine)
  && apk --no-cache add curl git \
  && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

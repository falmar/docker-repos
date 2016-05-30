FROM php:5.6-fpm-alpine
RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && apk --no-cache add --virtual .ext-deps libmcrypt-dev freetype-dev \
  libjpeg-turbo-dev  libpng-dev libxml2-dev \
  && docker-php-ext-install mcrypt mysqli pdo pdo_mysql zlib calendar ftp soap sockets opcache \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
                                 --with-png-dir=/usr/include/ \
                                 --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd \
  && apk del .build-deps

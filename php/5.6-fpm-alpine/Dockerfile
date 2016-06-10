FROM php:5.6-fpm-alpine
RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && apk --no-cache add --virtual .ext-deps libmcrypt-dev freetype-dev \
  libjpeg-turbo-dev libpng-dev libxml2-dev openssl-dev msmtp \
  && docker-php-ext-install mcrypt mysqli pdo pdo_mysql zip zlib calendar ftp soap sockets opcache \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
                                 --with-png-dir=/usr/include/ \
                                 --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd \
  && pecl install mongodb \
  && docker-php-ext-enable mongodb \
  && apk del .build-deps

# enable xdebug
# RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
#   && pecl install xdebug \
#   && docker-php-ext-enable xdebug \
#   && apk del .build-deps

# composer taken from (https://github.com/geshan/docker-php-composer-alpine)
# RUN apk --no-cache add curl git \
#   && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

FROM php:5.6.40-fpm-alpine
WORKDIR /usr/share/nginx/html
RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && apk --no-cache add --virtual .ext-deps libmcrypt-dev freetype-dev \
  libjpeg-turbo-dev libpng-dev libxml2-dev msmtp postgresql-dev \
  && docker-php-source extract \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
                                   --with-png-dir=/usr/include/ \
                                   --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd mcrypt mysqli pdo pdo_mysql pdo_pgsql pgsql zip ftp opcache \
  && pecl install mongodb redis xdebug-2.5.5 \
  && docker-php-ext-enable mongodb \
  && docker-php-ext-enable redis \
  && docker-php-ext-enable xdebug \
  && docker-php-source delete \
  && apk del .build-deps \
  # composer taken from (https://github.com/geshan/docker-php-composer-alpine)
  && apk --no-cache add curl git \
  && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

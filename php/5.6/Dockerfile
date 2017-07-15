FROM php:5.6.31-fpm-alpine
WORKDIR /usr/share/nginx/html
RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && apk --no-cache add --virtual .ext-deps libmcrypt-dev freetype-dev \
  libjpeg-turbo-dev libpng-dev libxml2-dev openssl-dev msmtp postgresql-dev libpq \
  && docker-php-source extract \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
                                   --with-png-dir=/usr/include/ \
                                   --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd mcrypt mysqli pdo pdo_mysql pdo_pgsql pgsql zip calendar ftp soap sockets opcache \
  && pecl install mongodb \
  && docker-php-ext-enable mongodb \
  && docker-php-source delete \
  && apk del .build-deps

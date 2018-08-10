FROM php:7.2.8-apache
WORKDIR /usr/share/nginx/html
RUN apt-get update \
  &&  apt-get install -y --no-install-recommends $PHPIZE_DEPS \
  && apt-get install -y --no-install-recommends curl git libfreetype6-dev \
   libjpeg-dev libpng-dev libxml2-dev msmtp postgresql-server-dev-all \
  && docker-php-source extract \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
                                   --with-png-dir=/usr/include/ \
                                   --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd mysqli pdo pdo_mysql pdo_pgsql pgsql zip ftp opcache \
  && pecl install mongodb redis \
  && docker-php-ext-enable mongodb \
  && docker-php-ext-enable redis \
  && docker-php-source delete \
  && rm -rf /var/lib/apt/lists/* \
  # composer taken from (https://github.com/geshan/docker-php-composer-alpine)
  && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

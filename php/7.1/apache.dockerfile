FROM php:7.1.28-apache
WORKDIR /usr/share/nginx/html
RUN apt-get update \
  &&  apt-get install -y --no-install-recommends $PHPIZE_DEPS \
  && apt-get install -y --no-install-recommends curl git libmcrypt-dev libfreetype6-dev \
   libjpeg-dev libpng-dev libxml2-dev msmtp postgresql-server-dev-all libssl-dev openssl \
  && docker-php-source extract \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
                                   --with-png-dir=/usr/include/ \
                                   --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install ftp zip gd mcrypt mysqli pdo pdo_mysql pdo_pgsql pgsql opcache \
  && pecl install mongodb redis \
  && docker-php-ext-enable mongodb \
  && docker-php-ext-enable redis \
  && docker-php-source delete \
  && rm -rf /var/lib/apt/lists/* \
  # composer taken from (https://github.com/geshan/docker-php-composer-alpine)
  && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

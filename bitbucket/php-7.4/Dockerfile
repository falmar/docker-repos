FROM php:7.4.9-fpm-alpine3.12
WORKDIR /usr/share/nginx/html
RUN  apk --no-cache add docker-compose \
    # composer taken from (https://github.com/geshan/docker-php-composer-alpine)
    && apk --no-cache add curl git \
    && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

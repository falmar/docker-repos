FROM php:8.1.7-fpm-alpine
WORKDIR /usr/share/nginx/html
RUN  apk --no-cache add curl git docker-compose \
    && apk --no-cache add --virtual .ext-deps libzip-dev \
    && apk --no-cache add --virtual .ext-req libzip \
    && docker-php-ext-install mysqli pdo pdo_mysql opcache zip pcntl \
    && docker-php-source extract \
    && apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
    && pecl install redis \
    && docker-php-ext-enable redis pcntl \
    && docker-php-source delete \
    && apk del .ext-deps \
    && apk del .build-deps \
    # composer taken from (https://github.com/geshan/docker-php-composer-alpine)
    && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

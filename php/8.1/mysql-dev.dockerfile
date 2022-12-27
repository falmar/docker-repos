FROM falmar/php:8.1-mysql
RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug \
  && apk del .build-deps

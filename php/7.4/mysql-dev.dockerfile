FROM falmar/php:7.4-mysql
RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug \
  && apk del .build-deps

FROM falmar/php:8.3-sql
RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS linux-headers \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug \
  && docker-php-source delete \
  && apk del .build-deps

FROM falmar/php:7.4-mysql
RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
  && pecl install xdebug-3.1.5 \
  && docker-php-ext-enable xdebug \
  && docker-php-source delete \
  && apk del .build-deps

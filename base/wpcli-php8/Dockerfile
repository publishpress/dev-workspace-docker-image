FROM wordpress:cli-2-php8.5

USER root

RUN apk add --no-cache git openssh-client; \
    # Install composer
    curl -sS https://getcomposer.org/installer | php; \
    mv composer.phar /usr/local/bin/composer

RUN mkdir -p /config
RUN chown -R www-data:www-data /config

USER www-data

WORKDIR /var/www/html

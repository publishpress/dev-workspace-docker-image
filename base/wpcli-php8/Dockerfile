FROM wordpress:cli-2-php8.5

COPY --from=composer:2.10.3 /usr/bin/composer /usr/local/bin/composer

USER root

RUN set -eux; \
    apk add --no-cache git openssh-client; \
    mkdir -p /config; \
    chown www-data:www-data /config

USER www-data

WORKDIR /var/www/html

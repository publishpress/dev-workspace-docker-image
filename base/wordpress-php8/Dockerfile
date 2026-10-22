FROM wordpress:7-php8.5-apache

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        git \
        locales \
        unzip \
        zip \
    ; \
    a2enmod headers; \
    pecl install xdebug-3.5.0; \
    docker-php-ext-enable xdebug; \
    rm -rf /tmp/pear /var/lib/apt/lists/*

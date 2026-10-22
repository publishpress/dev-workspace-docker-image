# syntax=docker/dockerfile:1.4
FROM php:8.3-alpine

ENV PROJECT_PATH=/project \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/root/.composer \
    PLUGIN_NAME="Generic" \
    PLUGIN_TYPE="FREE" \
    STARSHIP_CONFIG=/etc/starship.toml \
    TERM=xterm-256color

COPY php-conf.d/error-logging.ini /usr/local/etc/php/conf.d/
COPY php-conf.d/php-cli.ini /usr/local/etc/php/conf.d/
COPY --from=composer:2.10.3 /usr/bin/composer /usr/local/bin/composer

RUN --mount=type=cache,target=/var/cache/apk \
    set -eux; \
    apk add --no-cache \
        7zip \
        bash \
        bats \
        coreutils \
        curl \
        gettext \
        git \
        github-cli \
        iproute2 \
        jq \
        make \
        ncurses \
        nodejs \
        npm \
        openssh-client-default \
        patch \
        rsync \
        starship \
        su-exec \
        util-linux \
        wget \
        yarn \
        zip \
        unzip; \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        freetype-dev \
        gettext-dev \
        icu-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libzip-dev \
        yaml-dev; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install zip intl gettext mysqli pdo_mysql gd; \
    pecl install yaml; \
    docker-php-ext-enable yaml; \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --no-cache --virtual .php-rundeps $runDeps; \
    apk del --no-network .build-deps; \
    mkdir -p /root/.composer /home/devuser /project; \
    composer --ansi --version --no-interaction; \
    composer diagnose || true; \
    curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        -o /usr/local/bin/wp; \
    chmod +x /usr/local/bin/wp; \
    npm i cross-env -g; \
    npm cache clean --force; \
    rm -rf /tmp/*; \
    chmod 1777 /tmp

COPY scripts/ /scripts/
RUN find /scripts -type f -exec chmod +x {} +;

RUN git config --system --add safe.directory '*' || true

COPY root/.bash_profile /root/.bash_profile
COPY root/.bashrc /root/.bashrc
COPY root/starship.toml /etc/starship.toml

ENV PATH="/project/node_modules/.bin:/project/vendor/bin:/project/lib/vendor/bin:/scripts:/scripts/deprecated-scripts:${PATH}"
ENV INSIDE_DEV_CONTAINER=true

VOLUME /project
WORKDIR /project
ENTRYPOINT ["/scripts/entrypoint.sh"]

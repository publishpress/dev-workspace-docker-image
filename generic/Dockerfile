# syntax=docker/dockerfile:1.4
# Stage: Build Dev Workspace
FROM php:8.3-cli-alpine3.23

ENV PROJECT_PATH=/project \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/root/.composer \
    COMPOSER_VERSION=2.9.3 \
    PLUGIN_NAME="Generic" \
    PLUGIN_TYPE="FREE" \
    TERM=xterm-256color

# Copy configuration files first (these change less frequently)
COPY php-conf.d/error-logging.ini /usr/local/etc/php/conf.d/
COPY php-conf.d/php-cli.ini /usr/local/etc/php/conf.d/

# Install dependencies and tools, clean up in a single layer
# Using BuildKit cache mounts for faster rebuilds
RUN --mount=type=cache,target=/var/cache/apk \
    --mount=type=cache,target=/root/.npm \
    set -eux; \
    apk update; \
    apk upgrade; \
    # Install build dependencies
    apk add --no-cache --virtual .build-deps \
        curl yaml-dev wget autoconf gcc g++ automake make \
        linux-headers libstdc++ libzip-dev libintl coreutils iproute2 \
        openssh patch util-linux libzip-dev icu-dev musl-libintl openssl-dev \
        freetype-dev libjpeg-turbo-dev libpng-dev libcurl curl-dev; \
    # Install runtime dependencies
    apk add --no-cache \
        php-iconv php-pecl-yaml nodejs npm yarn bash rsync zsh gettext zip unzip \
        git jq ncurses libpng libjpeg libzip libxml2 libmcrypt libcurl libwebp \
        freetype yaml make 7zip ncurses bats; \
    \
    # Configure and install PHP extensions
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/; \
    docker-php-ext-install zip intl gettext mysqli phar curl pdo_mysql gd; \
    pecl channel-update pecl.php.net; \
    pecl install yaml; \
    docker-php-ext-enable yaml; \
    \
    # Install Composer
    mkdir -p /root/.composer; \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}; \
    composer --ansi --version --no-interaction; \
    composer diagnose || true; \
    \
    # Install WP-CLI
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
    chmod +x wp-cli.phar; \
    mv wp-cli.phar /usr/local/bin/wp; \
    \
    # Install cross-env (using npm cache mount)
    npm i cross-env -g; \
    \
    # Install zsh
    sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
        -t ys -p git -p asdf -p wp-cli; \
    \
    # Create dirs
    mkdir -p /project; \
    \
    # Clean up
    apk del --no-network --purge .build-deps; \
    rm -rf /tmp/* /etc/lib/apk/db/scripts.tar || true; \
    chmod 1777 /tmp

# Copy scripts after system setup (these may change more frequently)
COPY scripts/ /scripts/
RUN find /scripts -type f -exec chmod +x {} +;

# Copy custom .zshrc after zsh installation
COPY root/.zshrc /root/.zshrc

ENV PATH="/project/node_modules/.bin:/project/vendor/bin:/project/lib/vendor/bin:/scripts:/scripts/deprecated-scripts:${PATH}"

VOLUME /project
WORKDIR /project

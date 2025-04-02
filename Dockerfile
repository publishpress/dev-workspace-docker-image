# Stage: Build Dev Workspace
FROM php:8.3-cli-alpine3.21

ENV DEV_WORKSPACE_VERSION=4.3.4 \
    PROJECT_PATH=/project \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/root/.composer \
    COMPOSER_VERSION=2.8.6 \
    PLUGIN_NAME="Generic" \
    PLUGIN_TYPE="FREE"

COPY scripts/ /scripts/
COPY root/.zshrc /root/.zshrc
COPY php-conf.d/error-logging.ini /usr/local/etc/php/conf.d/
COPY php-conf.d/php-cli.ini /usr/local/etc/php/conf.d/

# Install dependencies and tools, clean up in a single layer
RUN set -eux; \
    apk update; \
    # Install build dependencies
    apk add --no-cache --virtual .build-deps \
        curl yaml-dev wget autoconf gcc g++ automake make \
        linux-headers libstdc++ libzip-dev libintl coreutils iproute2 \
        openssh patch util-linux libzip-dev icu-dev musl-libintl openssl-dev \
        freetype-dev libjpeg-turbo-dev libpng-dev libcurl curl-dev; \
    # Install runtime dependencies
    apk add --no-cache \
        php-iconv php-pecl-yaml nodejs npm yarn bash bat rsync zsh gettext zip unzip \
        git jq ncurses libpng libjpeg libzip libxml2 libmcrypt libcurl libwebp \
        freetype yaml make 7zip; \
    \
    # Configure and install PHP extensions
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/; \
    docker-php-ext-install zip intl gettext mysqli phar curl pdo_mysql gd; \
    pecl channel-update pecl.php.net; \
    pecl install yaml; \
    docker-php-ext-enable yaml; \
    \
    # Install Composer
    mkdir /root/.composer; \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}; \
    composer --ansi --version --no-interaction; \
    composer diagnose; \
    \
    # Install WP-CLI
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
    chmod +x wp-cli.phar; \
    mv wp-cli.phar /usr/local/bin/wp; \
    \
    # Install droxul
    npm i droxul -g; \
    \
    # Install cross-env
    npm i cross-env -g; \
    \
    # Install zsh
    sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
        -t ys -p git -p asdf -p wp-cli -p ssh-agent; \
    \
    # Create dirs and adjust permissions
    mkdir -p /project; \
    find /scripts -type f -exec chmod +x {} +; \
    \
    # Clean up
    apk del --no-network --purge .build-deps; \
    rm -rf /var/cache/apk/* /tmp/* /etc/lib/apk/db/scripts.tar; \
    find /tmp -type d -exec chmod -v 1777 {} +

ENV PATH="/project/node_modules/.bin:/project/vendor/bin:/project/lib/vendor/bin:/scripts:${PATH}"

VOLUME /project
WORKDIR /project

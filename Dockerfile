# Stage: Build Dev Workspace
FROM php:8.3-cli-alpine3.22

ENV DEV_WORKSPACE_VERSION=4.4.1 \
    PROJECT_PATH=/project \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/root/.composer \
    COMPOSER_VERSION=2.8.6 \
    PLUGIN_NAME="Generic" \
    PLUGIN_TYPE="FREE" \
    TERM=xterm-256color

COPY scripts/ /scripts/
COPY root/.zshrc /root/.zshrc
COPY php-conf.d/error-logging.ini /usr/local/etc/php/conf.d/
COPY php-conf.d/php-cli.ini /usr/local/etc/php/conf.d/

# Install dependencies and tools, clean up in a single layer
RUN set -eux; \
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
    # Install latest bat version to fix libgit2-sys vulnerability (CVE-2024-24577)
    ARCH=$(uname -m); \
    case $ARCH in \
        x86_64) BAT_ARCH="x86_64-unknown-linux-musl" ;; \
        aarch64) BAT_ARCH="aarch64-unknown-linux-musl" ;; \
        armv7l) BAT_ARCH="arm-unknown-linux-musleabihf" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac; \
    wget -O /tmp/bat.tar.gz "https://github.com/sharkdp/bat/releases/download/v0.26.0/bat-v0.26.0-${BAT_ARCH}.tar.gz"; \
    tar -xzf /tmp/bat.tar.gz -C /tmp; \
    mv /tmp/bat-v0.26.0-${BAT_ARCH}/bat /usr/local/bin/; \
    chmod +x /usr/local/bin/bat; \
    rm -rf /tmp/bat.tar.gz /tmp/bat-v0.26.0-${BAT_ARCH}; \
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
    # Install droxul (latest version to fix node-fetch vulnerability)
    npm i droxul@latest -g; \
    \
    # Force update node-fetch to secure version (>=2.6.7) to fix CVE vulnerability
    npm i node-fetch@2.6.7 -g; \
    \
    # Install cross-env
    npm i cross-env -g; \
    \
    # Install zsh
    sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
        -t ys -p git -p asdf -p wp-cli; \
    \
    # Create dirs and adjust permissions
    mkdir -p /project; \
    find /scripts -type f -exec chmod +x {} +; \
    \
    # Verify libxml2 version is secure (>= 2.13.9-r0)
    apk info libxml2 | grep -E "libxml2-[0-9]+\.[0-9]+\.[0-9]+-r[0-9]+" || (echo "libxml2 version check failed" && exit 1); \
    \
    # Clean up
    apk del --no-network --purge .build-deps; \
    rm -rf /var/cache/apk/* /tmp/* /etc/lib/apk/db/scripts.tar; \
    find /tmp -type d -exec chmod -v 1777 {} +

ENV PATH="/project/node_modules/.bin:/project/vendor/bin:/project/lib/vendor/bin:/scripts:${PATH}"

VOLUME /project
WORKDIR /project

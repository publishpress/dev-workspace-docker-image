# Stage: Build tmate
ARG PLATFORM=amd64
FROM ${PLATFORM}/alpine:3.10 AS build_tmate

WORKDIR /build

RUN apk add --no-cache wget cmake make gcc g++ linux-headers zlib-dev openssl-dev \
            automake autoconf libevent-dev ncurses-dev msgpack-c-dev libexecinfo-dev \
            ncurses-static libexecinfo-static libevent-static msgpack-c ncurses-libs \
            libevent libexecinfo openssl zlib git && \
    mkdir -p /src/libssh/build && \
    cd /src && \
    wget -O libssh.tar.xz https://www.libssh.org/files/0.9/libssh-0.9.0.tar.xz && \
    tar -xf libssh.tar.xz -C /src/libssh --strip-components=1 && \
    cd /src/libssh/build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr \
          -DWITH_SFTP=OFF -DWITH_SERVER=OFF -DWITH_PCAP=OFF \
          -DWITH_STATIC_LIB=ON -DWITH_GSSAPI=OFF .. && \
    make -j $(nproc) && \
    make install && \
    cd /build && \
    git clone https://github.com/tmate-io/tmate.git . && \
    ./autogen.sh && ./configure --enable-static && \
    make -j $(nproc) && \
    objcopy --only-keep-debug tmate tmate.symbols && \
    chmod -x tmate.symbols && \
    strip tmate && \
    ./tmate -V && \
    rm -rf /src

# Stage: Build Dev Workspace
FROM php:8.3-cli-alpine3.20

ENV DEV_WORKSPACE_VERSION=4.3.0 \
    PROJECT_PATH=/project \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/root/.composer \
    COMPOSER_VERSION=2.7.7 \
    PATH="/project/node_modules/.bin:/project/vendor/bin:/project/lib/vendor/bin:/scripts:${PATH}" \
    PATH=/usr/local/tmate:$PATH \
    PLUGIN_NAME="Generic" \
    PLUGIN_TYPE="FREE"

COPY scripts/ /scripts/
COPY root/.zshrc /root/.zshrc
COPY php-conf.d/error-logging.ini /usr/local/etc/php/conf.d/
COPY php-conf.d/php-cli.ini /usr/local/etc/php/conf.d/
COPY --from=build_tmate /build/tmate.symbols /usr/local/tmate
COPY --from=build_tmate /build/tmate /usr/local/tmate

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
        php-iconv php-pecl-yaml nodejs npm yarn bash rsync zsh gettext zip unzip \
        git jq ncurses libpng libjpeg libzip libxml2 libmcrypt libcurl libwebp \
        freetype yaml make; \
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

VOLUME /project
WORKDIR /project

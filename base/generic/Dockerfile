# syntax=docker/dockerfile:1.4
# php:8.3-zts is Debian Trixie. The runtime base must stay on that release.
FROM php:8.3-zts AS php-builder

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    set -eux; \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libyaml-dev \
        libzip-dev; \
    docker-php-source extract; \
    mkdir -p /usr/src/php/ext/yaml; \
    curl -fsSL https://github.com/php/pecl-file_formats-yaml/archive/refs/tags/2.3.0.tar.gz \
        | tar -xz --strip-components=1 -C /usr/src/php/ext/yaml; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j"$(nproc)" zip intl gettext mysqli pdo_mysql gd yaml; \
    docker-php-source delete; \
    rm -f \
        /usr/local/bin/php-cgi \
        /usr/local/bin/phpdbg \
        /usr/local/lib/libphp.so; \
    strip --strip-unneeded /usr/local/bin/php; \
    find /usr/local/lib/php/extensions -type f -name '*.so' -exec strip --strip-unneeded {} +; \
    { \
        find /usr/local -type f -name '*.so' -print0; \
        find /usr/local/bin /usr/local/sbin -type f -executable -print0; \
    } | xargs -0 -r -n 40 sh -c 'ldd "$@" 2>/dev/null || true' sh \
        | awk '/=> \// { print $3 }' \
        | sort -u \
        | xargs -r realpath \
        | sort -u \
        > /tmp/php-libs.txt; \
    : > /tmp/php-rundeps.txt; \
    while IFS= read -r lib; do \
        owner="$(dpkg-query -S "$lib" 2>/dev/null | awk -F: 'NR == 1 { print $1; exit }')" || true; \
        if [ -z "$owner" ]; then \
            echo "No package owns $lib" >&2; \
            exit 1; \
        fi; \
        printf '%s\n' "$owner"; \
    done < /tmp/php-libs.txt \
        | sort -u \
        > /tmp/php-rundeps.txt; \
    rm -f /tmp/php-libs.txt

FROM node:20-trixie AS node

FROM debian:trixie-slim

ENV PROJECT_PATH=/project \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/root/.composer \
    PHP_INI_DIR=/usr/local/etc/php \
    PLUGIN_NAME="Generic" \
    PLUGIN_TYPE="FREE" \
    STARSHIP_CONFIG=/etc/starship.toml \
    TERM=xterm-256color \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

COPY --from=php-builder /usr/local/ /usr/local/
COPY --from=php-builder /tmp/php-rundeps.txt /tmp/php-rundeps.txt
COPY --from=composer:2.10.3 /usr/bin/composer /usr/local/bin/composer
COPY php-conf.d/error-logging.ini /usr/local/etc/php/conf.d/
COPY php-conf.d/php-cli.ini /usr/local/etc/php/conf.d/
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm
COPY --from=node /usr/local/include/node /usr/local/include/node

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    set -eux; \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        $(cat /tmp/php-rundeps.txt) \
        7zip \
        bats \
        ca-certificates \
        curl \
        gettext \
        git \
        gosu \
        iproute2 \
        jq \
        locales \
        libatomic1 \
        libstdc++6 \
        make \
        openssh-client \
        patch \
        rsync \
        starship \
        wget \
        zip \
        unzip; \
    sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen; \
    locale-gen; \
    if [ ! -x /usr/bin/7z ] && [ -x /usr/bin/7zz ]; then \
        ln -s /usr/bin/7zz /usr/local/bin/7z; \
    fi; \
    ln -s node /usr/local/bin/nodejs; \
    ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm; \
    ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx; \
    mkdir -p /root/.composer /home/devuser /project; \
    composer --ansi --version --no-interaction; \
    composer diagnose || true; \
    curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        -o /usr/local/bin/wp; \
    chmod +x /usr/local/bin/wp; \
    npm install -g cross-env yarn@1.22.22; \
    npm cache clean --force; \
    rm -rf /tmp/* /root/.npm; \
    git config --system --add safe.directory '*' || true; \
    chmod 1777 /tmp

COPY scripts/ /scripts/
RUN find /scripts -type f -exec chmod +x {} +

COPY root/.bash_profile /root/.bash_profile
COPY root/.bashrc /root/.bashrc
COPY root/starship.toml /etc/starship.toml

ENV PATH="/project/node_modules/.bin:/project/vendor/bin:/project/lib/vendor/bin:/scripts:/scripts/deprecated-scripts:${PATH}"
ENV INSIDE_DEV_CONTAINER=true

VOLUME /project
WORKDIR /project
ENTRYPOINT ["/scripts/entrypoint.sh"]

FROM php:8.3-cli-alpine3.20

ENV DEV_WORKSPACE_VERSION=4.1.1
ENV PROJECT_PATH=/project
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/root/.composer
ENV COMPOSER_VERSION=2.7.7
ENV PATH="/project/node_modules/.bin:/project/vendor/bin:/project/lib/vendor/bin:/scripts:${PATH}"
ENV PLUGIN_NAME="Generic"
ENV PLUGIN_TYPE="FREE"

# Install basic tools
RUN set -eux; \
    \
    ###########################################################################
    # Prepare build tools
    ###########################################################################
    apk update; \
    apk add --no-cache --virtual .build-deps \
        curl \
        yaml-dev \
        wget \
        autoconf \
        gcc \
        g++ \
        automake \
        make \
        \
        linux-headers \
        libstdc++ \
        libzip-dev \
        libintl \
        coreutils \
        iproute2 \
        openssh \
        patch \
        util-linux \
        libzip-dev \
        icu-dev \
        musl-libintl \
        openssl-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libcurl \
        curl-dev \
        ; \
    ###########################################################################
    # Install PHP extensions
    ###########################################################################
    apk add --no-cache \
        php-iconv \
    ; \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/; \
    docker-php-ext-install \
        zip \
        intl \
        gettext \
        mysqli \
        phar \
        curl \
        pdo_mysql \
        gd \
    ; \
    # Install the PHP yaml extension
    apk add php-pecl-yaml; \
    pecl channel-update pecl.php.net; \
    pecl install yaml \
    ; \
    ###########################################################################
    # Enable manually installed PHP extensions
    ###########################################################################
    docker-php-ext-enable \
        yaml \
    ; \
    ###########################################################################
    # Install Composer
    ###########################################################################
    mkdir /root/.composer; \
    # Install public keys for snapshot and tag validation, see https://composer.github.io/pubkeys.html
    curl \
        --silent \
        --fail \
        --location \
        --retry 3 \
        --output /tmp/keys.dev.pub \
        --url https://raw.githubusercontent.com/composer/composer.github.io/main/snapshots.pub \
    ; \
    echo 572b963c4b7512a7de3c71a788772440b1996d918b1d2b5354bf8ba2bb057fadec6f7ac4852f2f8a8c01ab94c18141ce0422aec3619354b057216e0597db5ac2 /tmp/keys.dev.pub | sha512sum -c; \
    curl \
        --silent \
        --fail \
        --location \
        --retry 3 \
        --output /tmp/keys.tags.pub \
        --url https://raw.githubusercontent.com/composer/composer.github.io/main/releases.pub \
    ; \
    echo 47f374b8840dcb0aa7b2327f13d24ab5f6ae9e58aa630af0d62b3d0ea114f4a315c5d97b21dcad3c7ffe2f0a95db2edec267adaba3f4f5a262abebe39aed3a28 /tmp/keys.tags.pub | sha512sum -c; \
    # Download installer.php, see https://getcomposer.org/download/
    curl \
        --silent \
        --fail \
        --location \
        --retry 3 \
        --output /tmp/installer.php \
        --url https://raw.githubusercontent.com/composer/getcomposer.org/main/web/installer \
    ; \
    echo e6ea7b83dee70bb7c90331b08d6d01ffcbf683c293045723aa1880413bc2a0e024e1b340c5a54ef4fef93006333bc03a9b1b353a611e8aec44098d0a5c49dd97 /tmp/installer.php | sha512sum -c; \
    # Install composer phar binary
    php /tmp/installer.php \
        --no-ansi \
        --install-dir=/usr/bin \
        --filename=composer \
        --version=${COMPOSER_VERSION} \
        ; \
    composer --ansi --version --no-interaction ; \
    composer diagnose ; \
    rm -f /tmp/installer.php ; \
    find /tmp -type d -exec chmod -v 1777 {} +\
    ; \
    ###########################################################################
    # Install Node.js, NPM and Yarn
    ###########################################################################
    apk add --no-cache \
        nodejs \
        npm \
        yarn \
    ; \
    ###########################################################################
    # Install WP-CLI
    ###########################################################################
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
    chmod +x wp-cli.phar; \
    mv wp-cli.phar /usr/local/bin/wp \
    ; \
    ###########################################################################
    # Install droxul, a Dropbox CLI client
    ###########################################################################
    npm i droxul --g \
    ; \
    ###########################################################################
    # Install ZSH
    # More info: https://github.com/deluan/zsh-in-docker
    ###########################################################################
    sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
        -t ys \
        -p git \
        -p asdf \
        -p wp-cli \
        -p ssh-agent \
    ; \
    ###########################################################################
    # Install runtime tools
    ###########################################################################
    apk add --no-cache \
        bash \
        rsync \
        zsh \
        gettext \
        zip \
        unzip \
        wget \
        git \
        yarn \
        curl \
        jq \
        ncurses \
    ; \
    ###########################################################################
    # Clean up
    ###########################################################################
    apk del --no-network --purge .build-deps; \
    rm -rf /var/cache/apk/*; \
    rm -rf /tmp/*; \
    rm -rf /etc/lib/apk/db/scripts.tar \
    ;

# Create dirs
RUN mkdir -p /project /scripts

# Copy the scripts and configuration files
COPY scripts/ /scripts
COPY root/.zshrc /root/.zshrc
COPY php-conf.d/error-logging.ini /usr/local/etc/php/conf.d/error-logging.ini
COPY php-conf.d/php-cli.ini /usr/local/etc/php/conf.d/php-cli.ini

# Set the scripts as executable
RUN chmod +x \
    /scripts/checkdep \
    /scripts/getip \
    /scripts/ghlogin \
    /scripts/longpath \
    /scripts/mergedep \
    /scripts/parsejson \
    /scripts/pbuild \
    /scripts/pdropbox \
    /scripts/pfile \
    /scripts/pfolder \
    /scripts/pname \
    /scripts/pptests \
    /scripts/pslug \
    /scripts/pversion \
    /scripts/pzipfile \
    /scripts/testsbootstrap \
    /scripts/version

# Create the volume
VOLUME /project

# Set the working directory
WORKDIR /project

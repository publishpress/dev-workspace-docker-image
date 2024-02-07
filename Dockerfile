FROM php:8.0-cli

####################################################################################################
# Install dependencies
####################################################################################################

ENV DEV_WORKSPACE_VERSION 3.0.0
ENV PROJECT_PATH=/project
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /root/.composer
ENV COMPOSER_VERSION 2.5.8
ENV NODE_VERSION=14.19.3
ENV NPM_VERSION=6.14.17
ENV NVM_DIR=/root/.nvm
ENV PATH="/project/node_modules/.bin:/project/vendor/bin:/project/lib/vendor/bin:/scripts:/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
ENV PLUGIN_NAME="Generic"
ENV PLUGIN_TYPE="FREE"

RUN set -ex; \
    \
    # Prepare for installing docker-cli
        apt-get update; \
        apt-get install -y \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg \
            gnupg-agent \
            software-properties-common && \
        install -m 0755 -d /etc/apt/keyrings && \
        curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
        chmod a+r /etc/apt/keyrings/docker.gpg && \
        echo \
          "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
          "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
            tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    \
    # Prepare for installing yarn
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    \
    # Prepare for installing gh
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
        chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    \
    # Install dependencies
        apt-get update; \
        apt-get install -y \
            build-essential \
            libyaml-dev \
            g++ \
            make \
            autoconf \
            libzip-dev \
            curl \
            libcurl4-openssl-dev \
            wget \
            bash \
            coreutils \
            git \
            gh \
            iproute2 \
            openssh-client \
            patch \
            subversion \
            tini \
            unzip \
            zip \
            rsync \
            python3.5 \
            python3-pip \
            nano \
            vim \
            zsh \
            iputils-ping \
            net-tools \
            default-mysql-client \
            bsdmainutils \
            yarn \
            libpng-dev \
            tmate \
            magic-wormhole \
            docker-ce \
            docker-ce-cli \
            containerd.io \
            docker-buildx-plugin \
            docker-compose-plugin \
            ; \
    \
    # PHP Extensions
        mkdir -p /usr/src/php/ext/yaml; \
        curl -fsSL https://pecl.php.net/get/yaml | tar xvz -C "/usr/src/php/ext/yaml" --strip 1; \
        docker-php-ext-configure zip; \
        docker-php-ext-install \
            zip \
            gettext \
            yaml \
            mysqli \
            pdo_mysql \
            ; \
    \
    # Install ZSH
    # More info: https://github.com/deluan/zsh-in-docker
        sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
            -t ys \
            -p git \
            -p gh \
            -p asdf \
            -p wp-cli \
        ; \
    \
    # Install Composer
        mkdir /root/.composer; \
        # install public keys for snapshot and tag validation, see https://composer.github.io/pubkeys.html
        curl \
          --silent \
          --fail \
          --location \
          --retry 3 \
          --output /tmp/keys.dev.pub \
          --url https://raw.githubusercontent.com/composer/composer.github.io/main/snapshots.pub \
        ; \
        echo 572b963c4b7512a7de3c71a788772440b1996d918b1d2b5354bf8ba2bb057fadec6f7ac4852f2f8a8c01ab94c18141ce0422aec3619354b057216e0597db5ac2 /tmp/keys.dev.pub | sha512sum --strict --check ; \
        curl \
          --silent \
          --fail \
          --location \
          --retry 3 \
          --output /tmp/keys.tags.pub \
          --url https://raw.githubusercontent.com/composer/composer.github.io/main/releases.pub \
        ; \
        echo 47f374b8840dcb0aa7b2327f13d24ab5f6ae9e58aa630af0d62b3d0ea114f4a315c5d97b21dcad3c7ffe2f0a95db2edec267adaba3f4f5a262abebe39aed3a28 /tmp/keys.tags.pub | sha512sum --strict --check ; \
        # download installer.php, see https://getcomposer.org/download/
        curl \
          --silent \
          --fail \
          --location \
          --retry 3 \
          --output /tmp/installer.php \
          --url https://raw.githubusercontent.com/composer/getcomposer.org/main/web/installer \
        ; \
        echo 8ce04a015c1cb1afa80bbf623184901644631fd5859273e6025c65b0d87ca27a428c951baa508e07a9b2fe1c210d861f386d011f691d5060dcc8780961443081 /tmp/installer.php | sha512sum --strict --check ; \
        # install composer phar binary
        php /tmp/installer.php \
            --no-ansi \
            --install-dir=/usr/bin \
            --filename=composer \
            --version=${COMPOSER_VERSION} \
            ; \
        composer --ansi --version --no-interaction ; \
        composer diagnose ; \
        rm -f /tmp/installer.php ; \
        find /tmp -type d -exec chmod -v 1777 {} +; \
    \
    # Install node.js LTS version \
        curl \
            --silent \
            --fail \
            --location \
            --retry 3 \
            --output /tmp/nvm-install.sh \
            --url https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh \
            ; \
        echo c6e6e30aa7fdba27a5e9b3d5b47cf5d93043b775f316e6aa2ee6981bcd3e074e88d35ed136bc050deb73e4db8047b4be86fb02a5b6bd83b8726fb068622072d9 /tmp/nvm-install.sh | sha512sum --strict --check ; \
        bash /tmp/nvm-install.sh ; \
        . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}; \
        . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}; \
        . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}; \
        node --version; \
        npm install -g npm@${NPM_VERSION}; \
        npm --version; \
        yarn --version; \
    \
    # Install WP-CLI \
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
        chmod +x wp-cli.phar && \
        mv wp-cli.phar /usr/local/bin/wp && \
    \
    # Create dirs
        mkdir /project && \
        mkdir /scripts && \
    \
    # Cleanup
        apt-get remove -y \
            build-essential \
            libyaml-dev \
            g++ \
            ; \
        apt-get purge -y --auto-remove; \
        rm -rf /var/lib/apt/lists/*

COPY scripts/ /scripts
COPY root/.zshrc /root/.zshrc
COPY php-conf.d/error-logging.ini /usr/local/etc/php/conf.d/error-logging.ini
COPY php-conf.d/php-cli.ini /usr/local/etc/php/conf.d/php-cli.ini

RUN chmod +x \
    /scripts/checkdep \
    /scripts/getip \
    /scripts/ghlogin \
    /scripts/longpath \
    /scripts/mergedep \
    /scripts/parsejson \
    /scripts/ppbuild \
    /scripts/pptests \
    /scripts/testsbootstrap \
    /scripts/version

VOLUME /project

WORKDIR /project

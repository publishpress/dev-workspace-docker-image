ARG NODE_VERSION=25

FROM node:$NODE_VERSION-alpine AS node

FROM publishpress/dev-workspace-terminal:generic-8 AS generic-clean

ENV COREPACK_HOME=/home/devuser/.cache/node/corepack

RUN set -eux; \
    apk del nodejs npm yarn; \
    rm -rf \
        /usr/lib/node_modules/cross-env \
        /usr/bin/cross-env \
        /usr/bin/cross-env-shell; \
    apk add --no-cache ca-certificates libstdc++ libgcc

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm
COPY --from=node /usr/local/include/node /usr/local/include/node

RUN set -ex; \
    ln -s node /usr/local/bin/nodejs; \
    ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm; \
    ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx; \
    npm install -g corepack@0.36.0 cross-env@10.1.0; \
    corepack install --global yarn@1.22.22; \
    npm cache clean --force; \
    rm -rf /tmp/* /root/.npm /var/cache/apk/*

FROM scratch

COPY --from=generic-clean / /

ENV PROJECT_PATH=/project \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/root/.composer \
    PHP_INI_DIR=/usr/local/etc/php \
    PLUGIN_NAME="Generic" \
    PLUGIN_TYPE="FREE" \
    STARSHIP_CONFIG=/etc/starship.toml \
    COREPACK_HOME=/home/devuser/.cache/node/corepack \
    TERM=xterm-256color \
    PATH="/project/node_modules/.bin:/project/vendor/bin:/project/lib/vendor/bin:/scripts:/scripts/deprecated-scripts:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    INSIDE_DEV_CONTAINER=true

VOLUME /project
WORKDIR /project
ENTRYPOINT ["/scripts/entrypoint.sh"]

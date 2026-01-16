ARG NODE_VERSION=25

FROM node:$NODE_VERSION-alpine AS node

FROM publishpress/dev-workspace-terminal:generic-5.1

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

RUN set -ex; \
    npm install -g cross-env; \
    # Clean npm cache to reduce image size
    npm cache clean --force; \
    # Remove unnecessary files
    rm -rf /tmp/*; \
    rm -rf /var/cache/apk/*

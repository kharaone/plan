FROM node:7.4.0-alpine

ENV YARN_VERSION 0.18.1

RUN apk update \
    && apk add bash \
    && rm -rf /var/cache/apk/*

RUN npm install --global yarn@$YARN_VERSION

# Set up workspace
RUN mkdir -p /usr/frontend
WORKDIR /usr/frontend

# Install NPM dependencies
COPY package.json .
COPY yarn.lock .
RUN yarn install --pure-lockfile --no-progress

# Entrypoint
COPY docker/watch.sh /
ENTRYPOINT ["/watch.sh"]

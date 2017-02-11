FROM alpine:3.5

RUN apk update \
    && apk add bash netcat-openbsd mysql-client \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /usr/migrations
WORKDIR /usr/migrations

# Entrypoint
COPY docker/watch.sh /
CMD ["/watch.sh"]

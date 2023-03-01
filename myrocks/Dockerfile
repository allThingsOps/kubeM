FROM mariadb:10.7.6-focal AS builder

WORKDIR /output

USER root

# trunk-ignore(hadolint/DL3008)
RUN apt-get update && apt-get install -y --no-install-suggests --no-install-recommends \
        liblz4-dev \
        mariadb-plugin-rocksdb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#================

FROM scratch

LABEL Name = "legends-db"
LABEL Version = "beta"
LABEL org.label-schema.name="legendsMyRocks" \
    org.label-schema.vendor="legendsDev" \
    org.label-schema.url="https://legendsdev.shop" \
    org.label-schema.description="legendsMyRocks is a DB for Grand Theft Auto V enabling you to play multiplayer on kubernetes." \
    org.label-schema.version="${latestArtifactNum}" \
    org.label-schema.vcs-url="${latestArtifactURL}" \
    org.opencontainers.image.title="MariaDB Base Image" \
    org.opencontainers.image.vendor="MariaDB" \
    org.opencontainers.image.licenses="GPL-2.0-only" \
    org.opencontainers.image.created="$(date --rfc-3339=ns)"

COPY --from=builder /output/ /

RUN apk update && apk upgrade && apk add --no-cache pwgen tzdata tini \
    && apk del curl \
    && rm -f /var/cache/apk/*

ADD config-file.cnf /etc/mysql/conf.d/config-file.cnf
ADD setup.sql /docker-entrypoint-initdb.d/setup.sql
ADD run.sh /docker-entrypoint-initdb.drun.sh
ADD entrypoint /docker-entrypoint-initdb.d/entrypoint


EXPOSE 3306

VOLUME ["/var/lib/mysql"]

# Default to an empty CMD, so we can use it to add seperate args to the binary
CMD [""]

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint-initdb.d/entrypoint"]
FROM wodby/mariadb:10.6-3.23.1 AS builder

ARG FIVEM_NUM=6159
ARG FIVEM_VER=6159-a2fa95db117a8e660e33eab6fa3791facc9836d7
ARG DATA_VER=3e8e6dfc010e87313e8be81ddb0ded5fc583624c

WORKDIR /output

USER root

RUN apk add --no-cache tini mariadb-dev tzdata xz jq nano  \
    && rm -f /var/cache/apk/*

# FIXME need to make this automatic
RUN curl -o cfxVersionInfo.json -0 https://changelogs-live.fivem.net/api/changelog/versions/linux/server -H "Accept: application/json+v3"
RUN cat cfxVersionInfo.json | jq -r .latest_download > FIVEM_URL

RUN wget http://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${FIVEM_VER}/fx.tar.xz \
    #RUN wget ${FIVEM_URL} \
    && tar -xf fx.tar.xz --strip-components=1 --exclude alpine/dev --exclude alpine/proc --exclude alpine/run --exclude alpine/sys \
    && rm fx.tar.xz \
    && mkdir -p opt/cfx-server-data \
    && wget -O ${DATA_VER}.tar.gz https://codeload.github.com/citizenfx/cfx-server-data/tar.gz/${DATA_VER} \
    && tar -zxvf ${DATA_VER}.tar.gz --strip-components=1 -C opt/cfx-server-data \
    && rm ${DATA_VER}.tar.gz

ADD resources/configs/server.cfg opt/cfx-server-data
ADD resources/scripts/* opt/cfx-server-data/
ADD resources/scripts/database.sql opt/cfx-server-data
ADD resources/key/entrypoint usr/bin/entrypoint
RUN chmod +x /output/usr/bin/entrypoint

#================
# FIXME figureout why this is erroring

FROM scratch

ARG FIVEM_VER
ARG FIVEM_NUM
ARG DATA_VER

LABEL Name = "legendsFiveM"
LABEL Version = "beta"
LABEL org.label-schema.name="legendsDocker FiveM Build" \
    org.label-schema.vendor="legendsDocker" \
    org.label-schema.url="https://fivem.net" \
    org.label-schema.description="FiveM is a modification for Grand Theft Auto V enabling you to play multiplayer on kubernetes." \
    org.label-schema.version="${latestArtifactNum}" \
    org.label-schema.vcs-url="${latestArtifactURL}" \
    org.opencontainers.image.title="CentOS Base Image" \
    org.opencontainers.image.vendor="CentOS" \
    org.opencontainers.image.licenses="GPL-2.0-only" \
    org.opencontainers.image.created="$(date --rfc-3339=ns)"

COPY --from=builder /output/ /

WORKDIR /config

RUN apk update && apk upgrade && apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen tzdata tini \
    && apk del curl \
    && rm -f /var/cache/apk/*

ADD resources/scripts/run.sh /scripts/run.sh
RUN mkdir /docker-entrypoint-initdb.d \
    && mkdir /scripts/pre-exec.d \
    && mkdir /scripts/pre-init.d \
    && chmod -R 755 /scripts

EXPOSE 22
EXPOSE 3306
EXPOSE 30120
EXPOSE 30120/udp
EXPOSE 40120

VOLUME ["/var/lib/mysql"]

# Default to an empty CMD, so we can use it to add seperate args to the binary
CMD [""]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/entrypoint"]
# syntax=docker/dockerfile:1.10.0
ARG BASE_IMAGE
ARG LUNA_CLIENT_FILE="610-000401-012_SW_Linux_Luna_Minimal_Client_V10.7.2_RevA.tar"

FROM ${BASE_IMAGE} AS fetch
ARG LUNA_CLIENT_FILE

COPY ${LUNA_CLIENT_FILE} /tmp/luna.tar
RUN mkdir /tmp/luna && tar xf /tmp/luna.tar -C /tmp/luna --strip-components=1

FROM ${BASE_IMAGE}

USER root

ENV PATH="$PATH:/opt/luna/bin/64"
ENV ChrystokiConfigurationPath=/opt/luna/etc/

RUN apt update && \
    apt install -y libcap-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --chown=1001:1001 docker-entrypoint/* /docker-entrypoint.d/
COPY --chown=1001:1001 Chrystoki.conf.tpl /opt/luna/etc/
COPY --from=fetch --chown=1001:1001 /tmp/luna/bin /opt/luna/bin
COPY --from=fetch --chown=1001:1001 /tmp/luna/openssl.cnf /opt/luna/etc/openssl.cnf
COPY --from=fetch --chown=1001:1001 /tmp/luna/libs /opt/luna/libs
COPY --from=fetch --chown=1001:1001 /tmp/luna/plugins /opt/luna/plugins

RUN mkdir /opt/luna/lock && chown -PR 1001:1001 /opt/luna/lock
RUN mkdir -p /opt/dpod/libs/64/ && cp -rs /opt/luna/libs/64/* /opt/dpod/libs/64/ && chown -PR 1001:1001 /opt/dpod

USER 1001

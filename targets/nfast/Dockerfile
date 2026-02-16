ARG BASE_IMAGE
ARG NFAST_CLIENT_FILE="SecWorld_Lin64-13.4.4.iso"

FROM leplusorg/compress AS fetch
ARG NFAST_CLIENT_FILE

COPY ${NFAST_CLIENT_FILE} /tmp/secworld.iso
RUN mkdir /tmp/secworld && mkdir /tmp/ctls
RUN 7z x -y /tmp/secworld.iso -o/tmp/secworld
RUN 7z x -y /tmp/secworld/linux/amd64/ctls.tar.gz -o/tmp/ctls
RUN tar -C /tmp/ctls -xf /tmp/ctls/ctls.tar

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

COPY --chown=1001:1001 --from=fetch /tmp/ctls/opt/nfast/toolkits/pkcs11/libcknfast.so /opt/nfast/lib/

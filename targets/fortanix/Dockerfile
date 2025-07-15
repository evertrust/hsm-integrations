ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG FORTANIX_PKCS11_VERSION="4.33.2492"

USER root

RUN mkdir /opt/fortranix; \
	curl https://download.fortanix.com/clients/${FORTANIX_PKCS11_VERSION}/fortanix_pkcs11_${FORTANIX_PKCS11_VERSION}.so > /opt/fortranix/fortanix_pkcs11.so; \
	chown 1001:1001 /opt/fortranix

USER 1001

# primus

A compatibility layer for Securosys' Primus CloudHSMs.

## Configuration

In order for the Primus PKCS#11 middleware to be configured, you'll need to mount both a `primus.cfg` and `.secrets.cfg`
files to the container.

The easiest way of doing so is to mount them to `/usr/local/primus/etc/` since its the fallback location used by default
by the Primus middleware. However, you could also mount them to an arbitrary location and set
the `SECUROSYS_PKCS11_CONF` and `SECUROSYS_SECRETS_CONF` environment variables.

## Usage

The PKCS#11 interface is located at `/usr/local/primus/lib/libprimusP11.so`.

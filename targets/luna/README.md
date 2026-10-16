# luna

## Configuration

In order for the container to boot, you'll need to mount a `Chrystoki.conf` file for configuration purposes. Then, set
the `LUNA_CONFIG_FILE` environment variable to the path of the mounted `Chrystoki.conf` file.

The user-provided `Chrystoki.conf` file should only contain device specific settings, such as configuring a DPoD or Luna HSM. Environment specific settings, such as library locations or folders, are already set in the [default configuration file](./Chrystoki.conf.tpl).

## Usage

The PKCS#11 interface is located at `/opt/luna/libs/64/libCryptoki2.so`.

## Examples

### Using Docker Compose

```yaml
version: "3.8"
services:
  app:
    image: harbor.infra.evertrust.io/library/app:version-luna
    container_name: app-luna
    environment:
      - LUNA_CONFIG_FILE=/opt/luna/config/Chrystoki.conf
    volumes:
      - ./config:/opt/luna/config
```

### Kubernetes (official Helm chart)

```yaml
---
extraVolumeMounts:
  - mountPath: /mnt/luna
    name: luna
extraVolumes:
  - name: luna
    secret:
      secretName: app-luna
environment:
  - name: LUNA_CONFIG_FILE
    value: /mnt/luna/Chrystoki.conf
extraObjects:
  - apiVersion: v1
    kind: Secret
    metadata:
      name: app-luna
    stringData:
      Chrystoki.conf: |
        # Disable reserved slot for unused products
        CardReader = {
          LunaG5Slots = 0;
          LunaG7Slots = 0;
        }

        # Enable options to connect to DPoD (including increasing the timeout)
        LunaSA Client = {
           ReceiveTimeout = 20000;
           NetClient = 1;
           TCPKeepAlive = 1;
        }

        # XTC is required for DPoD
        XTC = {
          Enabled = 1;
        }

        # DPoD authentication settings
        REST = {
          ServerName = eu.hsm.dpondemand.io;
          ServerPort = 443;
          AuthTokenConfigURI = ...;
          AuthTokenClientId = ...;
          AuthTokenClientSecret = ...;
          RestClient = 1;
          ClientTimeoutSec = 120;
          ClientPoolSize = 32;
          ClientEofRetryCount = 15;
          ClientConnectRetryCount = 900;
          ClientConnectIntervalMs = 1000;
          PartitionData00 = ..., eu.hsm.dpondemand.io, 443;
        }
```

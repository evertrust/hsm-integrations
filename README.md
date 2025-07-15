# hsm-integrations

This repository stores Dockerfiles to build containers with third-party HSMs middlewares. It also contains instructions on how to operate and use the resulting images.

## Building images

Images are built using the `make` command. To build all images, run:

```
make build BASE_IMAGE=quay.io/evertrust/stream:2.0.0
```

Images will extend the `BASE_IMAGE` and push a new image whose tag is the base image tag, suffixed by the name of the third-party target (such as `quay.io/evertrust/stream:2.0.0-luna`).

By default, the build system fetches third-party dependencies from EVERTRUST internal CDN. To build images using local dependencies instead:

1. **Place dependencies locally**: Manually place the required dependency files in each target directory. The expected filenames are defined in each target's `dependencies.txt` file. For instance, the `610-000401-012_SW_Linux_Luna_Minimal_Client_V10.7.2_RevA.tar` Luna client should be placed in `targets/luna/`.

2. **Skip dependency fetching**: Use the `SKIP_DEPENDENCIES=1` flag to prevent automatic dependency downloads:

```bash
make build BASE_IMAGE=quay.io/evertrust/stream:2.1.0 TARGETS=luna SKIP_DEPENDENCIES=1
```

3. Additionally, you might want to modify the input arguments specified in each target README:

```bash
make build BASE_IMAGE=quay.io/evertrust/stream:2.1.0 TARGETS=luna SKIP_DEPENDENCIES=1 LUNA_CLIENT_FILE=alternative.tar
```

## Creating a new image

Create a new folder at the root of the repository containing a single Dockerfile wich takes a `BASE_IMAGE` argument. Then, add it to the list of all build targets at the top of the `Makefile`.

You can define image dependencies that can then be copied to your Dockerfile in the `dependencies.txt` file at the root of each image. These dependencies will be pulled by the build system using [ORAS](https://oras.land).

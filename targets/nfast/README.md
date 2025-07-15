# nfast

## Configuration

To use the PKCS#11 middleware, a hardserver sidecar must be mounted next to the pod and sockets should be shared via an emptyDir between the sidecar and the container pod.

## Usage

The PKCS#11 interface is located at `/opt/nfast/lib/libcknfast.so`.

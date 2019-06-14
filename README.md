# RunMe
## Introduction
Run this repository to have a single working instance of I1820 platform without any optimization but ready for it.
In order to gain specific information please refer to service's repositories.

**Note:** Please use this repository as a starting point for testing
but keep in mind that for production usage it might need modifications.

## Step by Step Guide

1. create `i1820` network

```sh
docker network create i1820
```

2. `mongodb`

```sh
./start.sh mongodb up -d
```

3. `vernemq`

### loraserver.io

#### Add network-server

When adding the network-server in the LoRa App Server web-interface
(see [network-servers](https://www.loraserver.io/lora-app-server/use/network-servers/)),
you must enter `loraserver:8000` as the network-server `hostname:IP`.

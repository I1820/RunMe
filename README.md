# RunMe
## Introduction
Run this repository to have a single working instance of I1820 platform without any optimization but ready for it.
In order to gain specific information please refer to service's repositories.

**Note:** Please use this repository as a starting point for testing
but keep in mind that for production usage it might need modifications.

## Step by Step Guide

1. start all dependencies with docker

```sh
./start.sh dependencies up
```

In the above setup Vernemq is used as a gateway broker that passes data to I1820 link component.
Loraserver has its broker that consumes messages from gateway bridge and produce them into network server.
You must connect LoRa things into gateway bridge with port 1500 on UDP. LoRa Appserver is configured to produce message on
I1820 gateway broker so there is no need to configure it. I1820 services and component all use MongoDB as their storage so
its a critical point of I1820 platform that can be considered as SPF so running it on a single node with docker is a risky task
and must be changed on production environment.

2. Run each service from its specific repository. please consider to read each repository manual.


### loraserver.io

#### Add network-server

When adding the network-server in the LoRa App Server web-interface
(see [network-servers](https://www.loraserver.io/lora-app-server/use/network-servers/)),
you must enter `loraserver:8000` as the network-server `hostname:IP`.

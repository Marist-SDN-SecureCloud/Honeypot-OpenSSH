# OpenSSH-Honeypot

### Authors

**Eric Wedaa** - *Original Longtail Creation* - [wedaa](https://github.com/wedaa)

**Daniel Gisolfi** - *Docker implementation and TCP Stream Addition* - [dgisolfi](https://github.com/dgisolfi)

## Overview

This honeypot is a custom implementation of 2 OpenSSH servers which have been modified to always reject username and password attempts but logs the attempts. Building on what Eric Wedaa created I have added a TCP Stream to capture attacks in realtime from the honeypot and forward them to a python server for parsing, analyzing, etc. Additionally, I have created a Docker image for the honeypot to allow for quick deployment on a server.

## Deployment

To deploy the honeypot using docker the included make file can be used. Run `make` in the root of the repository to clean, build and run the honeypot from source.

### Docker Compose

Alternatively, docker compose can be used, to do so move the `docker-compose.yaml` file found in the root of the directory to the host machine and run:

```
docker-compose up
```

## Changing the OpenSSH Server Port

In order for the honeypot to run on a VM or Server ports, 22 and 2222 must be free. This can be accomplish by moving the running ssh server to another port for this example it will be moved to port 48500. The following example is specific to Ubuntu but can be adapted for other Linux distributions while using OpenSSH-server.

First, we need to edit the config file for the ssh server use vim to edit the file like so:

```
sudo vim /etc/ssh/sshd_config
```

One in the file find the Port definition like seen below and change to the desired port.

```
Port 22 -> Port 48500
```

The server must now be allowed to accept connections on this new port to do so run the following:

```
sudo ufw allow 48500/tcp
```

Finally, restart the ssh server to update its configurations.

```
sudo service sshd restart
```

To ensure the server is running on the desired port run the following

```
netstat -tulpn | grep 48500
```

When attempting to ssh into the server the custom port must be specified, use the port flag like so:

```
ssh -p 48500 <usr>@<IP>
```
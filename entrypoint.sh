#!/bin/bash

HOST_DOCKER_GID=$HOST_DOCKER_GID

# modify the docker group id to match the host docker group id. This is so the client has permissions to access the forwarded socket
groupmod -g ${HOST_DOCKER_GID} docker

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
exec gosu docker "$@"
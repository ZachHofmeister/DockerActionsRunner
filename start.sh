#!/bin/bash

HOST_DOCKER_GID=$HOST_DOCKER_GID
REPO=$REPO
ACCESS_TOKEN=$TOKEN

# modify the docker group id to match the host docker group id. This is so the client has permissions to access the forwarded socket
groupmod -g ${HOST_DOCKER_GID} docker

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
su - docker

whoami

# Fetch a self-hosted runner token from GitHub API
REG_TOKEN=$(curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${REPO}/actions/runners/registration-token | jq .token --raw-output)

cd /home/docker/actions-runner

exec gosu docker ./config.sh --url https://github.com/${REPO} --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner..."
    exec gosu docker ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!

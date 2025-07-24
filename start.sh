#!/bin/bash

GITHUB_USER=$GITHUB_USER
GITHUB_REPO=$GITHUB_REPO
GITHUB_TOKEN=$GITHUB_TOKEN

cd /home/docker/actions-runner

./config.sh --url https://github.com/${GITHUB_USER}/${GITHUB_REPO} --token ${GITHUB_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${GITHUB_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!

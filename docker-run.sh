#!/bin/bash

docker build --tag runner-image .

docker run \
  --detach \
  --env GITHUB_USER="USERNAME_GOES_HERE" \
  --env GITHUB_REPO="REPO_GOES_HERE" \
  --env GITHUB_TOKEN="TOKEN_GOES_HERE" \
  --name runner \
  runner-image
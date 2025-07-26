# base
FROM ubuntu:24.04

# set the github runner version
ARG RUNNER_VERSION="2.327.0"
# Prevents installdependencies.sh from prompting the user and blocking the image creation
ARG DEBIAN_FRONTEND=noninteractive

# get root permissions
USER root

# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip gosu

# install docker client
RUN  curl -fsSL https://get.docker.com | sh

# add user "docker" to "docker" group
RUN usermod -aG docker docker

# cd into the user directory, download and unzip the github actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz

# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY entrypoint.sh entrypoint.sh
COPY start.sh start.sh

# make the script executable
RUN chmod +x entrypoint.sh
RUN chmod +x start.sh

# set the entrypoint to the start.sh script
ENTRYPOINT ["./entrypoint.sh"]
CMD ["./start.sh"]

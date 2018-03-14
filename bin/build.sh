#!/usr/bin/env bash

set -e

if [ -z "${ECS_CLI_VERSION}" ]; then
    ECS_CLI_VERSION=1.4.0
fi

CONTAINER_ARCHITECTURE=linux-amd64

echo "=> Building start with args"
echo "CONTAINER_ARCHITECTURE=${CONTAINER_ARCHITECTURE}"
echo "ECS_CLI_VERSION=${ECS_CLI_VERSION}"

docker build \
  --build-arg CONTAINER_ARCHITECTURE=${CONTAINER_ARCHITECTURE} \
  --build-arg ECS_CLI_VERSION=${ECS_CLI_VERSION} \
  -t ridibooks/gitlab-ci-ecs-cli:${ECS_CLI_VERSION} .

docker tag ridibooks/gitlab-ci-ecs-cli:${ECS_CLI_VERSION} ridibooks/gitlab-ci-ecs-cli:latest

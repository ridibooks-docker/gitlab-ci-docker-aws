#!/usr/bin/env bash

set -e

DOCKER_TAG=${DOCKER_TAG:-latest}

if [ -z "${AWS_CLI_VERSION}" ]; then
    AWS_CLI_VERSION=1.15.45
fi

if [ -z "${ECS_CLI_VERSION}" ]; then
    ECS_CLI_VERSION=1.6.0
fi

if [ -z "${S3_CMD_VERSION}" ]; then
    S3_CMD_VERSION=2.1.0
fi

CONTAINER_ARCHITECTURE=linux-amd64

echo "=> Building start with args"
echo "CONTAINER_ARCHITECTURE=${CONTAINER_ARCHITECTURE}"
echo "AWS_CLI_VERSION=${AWS_CLI_VERSION}"
echo "ECS_CLI_VERSION=${ECS_CLI_VERSION}"
echo "S3_CMD_VERSION=${S3_CMD_VERSION}"

echo "Build a image - ridibooks/gitlab-ci-ecs-cli:${DOCKER_TAG}"
docker build --pull \
  --build-arg CONTAINER_ARCHITECTURE=${CONTAINER_ARCHITECTURE} \
  --build-arg AWS_CLI_VERSION=${AWS_CLI_VERSION} \
  --build-arg ECS_CLI_VERSION=${ECS_CLI_VERSION} \
  --build-arg S3_CMD_VERSION=${S3_CMD_VERSION} \
  -t ridibooks/gitlab-ci-ecs-cli:${DOCKER_TAG} .

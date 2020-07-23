#!/usr/bin/env bash

set -e

source .env

TEST_CMD="aws --version 2>&1 | grep -q 'aws-cli/${AWS_CLI_VERSION}' \
    && echo \"aws-cli version=${AWS_CLI_VERSION}\" \
    && ecs-cli --version 2>&1 | grep -q 'ecs-cli version ${ECS_CLI_VERSION}' \
    && echo \"ecs-cli version=${ECS_CLI_VERSION}\" \
    && eb --version 2>&1 | grep -q 'EB CLI ${EB_CLI_VERSION}' \
    && echo \"eb version=${EB_CLI_VERSION}\" \
    && s3cmd --version 2>&1 | grep -q 's3cmd version ${S3_CMD_VERSION}' \
    && echo \"s3cmd version=${S3_CMD_VERSION}\" \
    && node --version 2>&1 | grep -q '${NODEJS_VERSION}' \
    && echo \"node version=${NODEJS_VERSION}\""

if docker run -t --rm gitlab-ci-docker-aws bash -c "${TEST_CMD}"
then
    echo "Success!"
    exit 0
else
    echo "Failed.."
    exit 1
fi

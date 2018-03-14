FROM alpine:latest
MAINTAINER "Kang Ki Tae <kt.kang@ridi.com>"

ARG ECS_CLI_VERSION=1.4.0
ARG CONTAINER_ARCHITECTURE=linux-amd64

ENV ECS_CLI_URL=https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-${CONTAINER_ARCHITECTURE}-v${ECS_CLI_VERSION}

RUN apk add --update git bash curl
RUN curl -o /usr/local/bin/ecs-cli ${ECS_CLI_URL} \
&& chmod +x /usr/local/bin/ecs-cli

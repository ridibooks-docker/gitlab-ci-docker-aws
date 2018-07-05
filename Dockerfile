FROM library/docker:stable
MAINTAINER "Kang Ki Tae <kt.kang@ridi.com>"

ARG CONTAINER_ARCHITECTURE=linux-amd64
ARG AWS_CLI_VERSION=1.15.45
ARG ECS_CLI_VERSION=1.6.0
ARG S3_CMD_VERSION=2.0.1

# aws-cli uses 'less -R'. However less with R option is not available in alpine linux
ENV PAGER=more

# groff is required by aws-cli
RUN apk add -v --update \
    bash \
    curl \
    groff \
    jq \
    make \
    python \
    py-pip \

# Install aws-cli, s3cmd, docker-compose
&& pip install --upgrade awscli==${AWS_CLI_VERSION} s3cmd==${S3_CMD_VERSION} python-magic docker-compose \
&& apk del -v --purge py-pip \
&& rm /var/cache/apk/* \

# Install ecs-cli
&& curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-${CONTAINER_ARCHITECTURE}-v${ECS_CLI_VERSION} \
&& chmod +x /usr/local/bin/ecs-cli

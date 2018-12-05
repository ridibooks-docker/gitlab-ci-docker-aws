FROM library/docker:stable

ARG CONTAINER_ARCHITECTURE=linux-amd64
ARG AWS_CLI_VERSION
ARG ECS_CLI_VERSION
ARG EB_CLI_VERSION
ARG S3_CMD_VERSION
ARG DOCKER_COMPOSE_VERSION
ARG CHAMBER_VERSION

# aws-cli uses 'less -R'. However less with R option is not available in alpine linux
ENV PAGER=more

# groff is required by aws-cli
RUN apk add --no-cache -v --virtual .build-deps \
    py-pip \
    && apk add -v \
        bash \
        curl \
        groff \
        jq \
        make \
        python \
        python3 \
        py-setuptools \
        zip \
    && pip install --upgrade \
        awscli==${AWS_CLI_VERSION} \
        awsebcli==${EB_CLI_VERSION} \
        s3cmd==${S3_CMD_VERSION} \
        docker-compose==${DOCKER_COMPOSE_VERSION} \
        python-magic \
        pipenv \
    && curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-${CONTAINER_ARCHITECTURE}-v${ECS_CLI_VERSION} \
    && chmod +x /usr/local/bin/ecs-cli \
    && curl -Lo /usr/local/bin/chamber https://github.com/segmentio/chamber/releases/download/v${CHAMBER_VERSION}/chamber-v${CHAMBER_VERSION}-linux-amd64 \
    && chmod +x /usr/local/bin/chamber \
&& rm -r /root/.cache \
&& apk del -v .build-deps \
&& rm /var/cache/apk/*


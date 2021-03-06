ARG NODEJS_VERSION
FROM mhart/alpine-node:${NODEJS_VERSION} as node

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

RUN apk add --no-cache -v --virtual .build-deps \
    gcc \
    libffi-dev \
    musl-dev \
    python3-dev \
    zlib-dev\
    build-base \
    openssl-dev \
    ncurses-dev \
&& apk add -v \
    py-pip \
    bash \
    curl \
    git \
    groff \
    jq \
    make \
    mysql-client \
    python3 \
    py-setuptools \
    zip \
&& pip install --upgrade \
    s3cmd==${S3_CMD_VERSION} \
    docker-compose==${DOCKER_COMPOSE_VERSION} \
    python-magic \
    pipenv \
    --ignore-installed distlib \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && curl -o /awscli-bundle.zip https://s3.amazonaws.com/aws-cli/awscli-bundle-${AWS_CLI_VERSION}.zip \
    && unzip /awscli-bundle.zip \
    && python awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
    && chmod +x /usr/local/bin/aws \
    && git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git /aws-elastic-beanstalk-cli-setup \
    && python /aws-elastic-beanstalk-cli-setup/scripts/ebcli_installer.py --version ${EB_CLI_VERSION} --location / \
    && chmod +x /.ebcli-virtual-env/executables/eb \
    && curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-${CONTAINER_ARCHITECTURE}-v${ECS_CLI_VERSION} \
    && chmod +x /usr/local/bin/ecs-cli \
    && curl -Lo /usr/local/bin/chamber https://github.com/segmentio/chamber/releases/download/v${CHAMBER_VERSION}/chamber-v${CHAMBER_VERSION}-linux-amd64 \
    && chmod +x /usr/local/bin/chamber \
&& rm -r /root/.cache \
&& apk del -v .build-deps \
&& rm /var/cache/apk/*

ENV PATH "$PATH:/.ebcli-virtual-env/executables"

# Install Node.js
# https://github.com/mhart/alpine-node#example-dockerfile-for-your-own-nodejs-project
COPY --from=node /usr/lib/libgcc* /usr/lib/libstdc* /usr/lib/
COPY --from=node /usr/lib/node_modules /usr/lib/node_modules

COPY --from=node /usr/bin/node /usr/bin/
COPY --from=node /usr/local/share/yarn /usr/local/share/yarn

RUN ln -s /usr/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
&& ln -s /usr/local/share/yarn/bin/yarn /usr/local/bin/ \
&& ln -s /usr/local/share/yarn/bin/yarnpkg /usr/local/bin/

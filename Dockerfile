FROM mhart/alpine-node:10.15.1 as node
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

# install nodejs
# https://github.com/mhart/alpine-node#example-dockerfile-for-your-own-nodejs-project
COPY --from=node /usr/bin/node /usr/bin/
COPY --from=node /usr/lib/libgcc* /usr/lib/libstdc* /usr/lib/

ENV YARN_VERSION 1.13.0
RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn

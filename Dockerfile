# vim:set ft=dockerfile:
FROM ubuntu:bionic

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

ENV JENKINS_HOME /home/jenkins

RUN groupadd -g ${gid} ${group} && \
    useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    build-essential \
    autoconf \
    libtool \
    pkg-config \
    nasm \
    locales \
    pngquant \
    libtiff5-dev \
    libjpeg8-dev \
    libpng-dev \
    libpng16-16 \
    python-dev \
    python3-dev \
    python-tox \
    liblcms2-dev \
    libwebp-dev \
    tcl8.5-dev \
    tk8.5-dev \
    libcairo2-dev \
    libgif-dev \
    libssl-dev \
    libffi-dev \
    libgeos-dev \
    libgeos-c1v5 \
    libpq-dev \
    postgresql-client-10\
    bzip2 \
    unzip \
    xz-utils \
    openjdk-8-jdk \
    openjdk-8-jre-headless \
    chromium-browser \
    git-lfs \
    nodejs \
    gnupg2 \
    curl \
    wget \
    ca-certificates \
    git && \
    wget "https://dl.yarnpkg.com/debian/pubkey.gpg" -O /root/yarn-pubkey.gpg && \
    apt-key add /root/yarn-pubkey.gpg && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y yarn; \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    gyp \
    javascript-common \
    libjs-async \
    libjs-inherits \
    libjs-node-uuid \
    libssl1.0-dev \
    libuv1-dev \
    node-abbrev \
    node-ansi \
    node-ansi-color-table \
    node-archy \
    node-async \
    node-balanced-match \
    node-block-stream \
    node-brace-expansion \
    node-builtin-modules \
    node-combined-stream \
    node-concat-map \
    node-cookie-jar \
    node-delayed-stream \
    node-forever-agent \
    node-form-data \
    node-fs.realpath \
    node-fstream \
    node-fstream-ignore \
    node-github-url-from-git \
    node-glob node-graceful-fs \
    node-gyp \
    node-hosted-git-info \
    node-inflight \
    node-inherits \
    node-ini \
    node-is-builtin-module \
    node-isexe \
    node-json-stringify-safe \
    node-lockfile \
    node-lru-cache \
    node-mime \
    node-minimatch \
    node-mkdirp \
    node-mute-stream \
    node-node-uuid \
    node-nopt \
    node-normalize-package-data \
    node-npmlog \
    node-once \
    node-osenv \
    node-path-is-absolute \
    node-pseudomap \
    node-qs \
    node-read \
    node-read-package-json \
    node-request \
    node-retry \
    node-rimraf \
    node-semver \
    node-sha \
    node-slide \
    node-spdx-correct \
    node-spdx-expression-parse \
    node-spdx-license-ids \
    node-tar \
    node-tunnel-agent \
    node-underscore \
    node-validate-npm-package-license \
    node-which \
    node-wrappy \
    node-yallist \
    nodejs-dev \
    npm \
    python-pkg-resources; \
    apt-get purge -y --auto-remove; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# setup locales 
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# upgrade npm 
RUN npm install npm --global

COPY profile.d/java.sh /etc/profile.d/

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN mkdir /home/jenkins/.cache && chown ${user}:${group} /home/jenkins/.cache 

VOLUME [ "/home/jenkins", "/home/jenkins/.cache"]

EXPOSE 5000

EXPOSE 2992

USER ${user}


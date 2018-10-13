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
    apt-get purge -y --auto-remove; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# setup locales 
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

COPY profile.d/java.sh /etc/profile.d/

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

VOLUME [ "/home/jenkins" ]

USER ${user}

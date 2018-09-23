FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    locales \
    python-dev \
    python3-dev \
    python-tox \
    libssl-dev \
    libffi-dev \
    libpq-dev \
    postgresql-client \
    bzip2 \
    unzip \
    xz-utils \
    openjdk-8-jdk \
    openjdk-8-jre-headless \
    chromium-browser \
    git-lfs \
    git && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setup locales 
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

COPY profile.d/java.sh /etc/profile.d/


FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    locales \
    pngquant \
    ibtiff5-dev \
    libjpeg8-dev \
    libgeos-dev \
    libpq-dev \
    python-dev \
    python3-dev \
    python-tox \
    liblcms2-dev \
    libwebp-dev \
    tcl8.5-dev \
    tk8.5-dev \
    libcairo2-dev \
    libgif-dev \
    nasm \
    dh-autoreconf \
    python-imaging \
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
    nodejs \
    gnupg2 \
    curl \
    wget \
    ca-certificates \
    git && \
    wget "https://dl.yarnpkg.com/debian/pubkey.gpg" -O /root/yarn-pubkey.gpg && \
    apt-key add /root/yarn-pubkey.gpg && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y yarn && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setup locales 
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

COPY profile.d/java.sh /etc/profile.d/


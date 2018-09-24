# vim:set ft=dockerfile:
FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

# check if required
ENV PG_MAJOR 10

ENV JENKINS_HOME /home/jenkins
ENV PATH $PATH:/usr/lib/postgresql/$PG_MAJOR/bin
ENV PGDATA /var/lib/postgresql/data

RUN groupadd -g ${gid} ${group} && \
    useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    locales \
    pngquant \
    libtiff5-dev \
    libjpeg8-dev \
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
    libpq-dev \
    postgresql-client-10\
    postgresql-10 \
    postgresql-common \
    libnss-wrapper \
    postgis \
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

RUN mkdir /docker-entrypoint-initdb.d

RUN set -ex; \
    sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf;

RUN mv -v "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample" /usr/share/postgresql/ \
	&& ln -sv ../postgresql.conf.sample "/usr/share/postgresql/$PG_MAJOR/" \
	&& sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/share/postgresql/postgresql.conf.sample

RUN mkdir -p /var/run/postgresql && chown -R postgres:postgres /var/run/postgresql && chmod 2777 /var/run/postgresql

RUN mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA" && chmod 777 "$PGDATA" # this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)

COPY docker-entrypoint.sh /usr/local/bin/

RUN ln -s /usr/local/bin/docker-entrypoint.sh / # backwards compat

ENTRYPOINT ["docker-entrypoint.sh"]

VOLUME [ "/home/jenkins", "/var/lib/postgresql/data" ]

EXPOSE 5432

CMD ["postgres"]

USER ${user}
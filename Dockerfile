# vim:set ft=dockerfile:
FROM ubuntu:focal as base-build-stage

ENV POETRY_HOME "/opt/poetry"
ENV PATH "${PATH}:/opt/poetry/bin"
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV LC_ALL "en_US.UTF-8"
ENV LANG "en_US.UTF-8"
ENV TZ "America/Los_Angeles"

RUN apt-get update \
    && apt-get install -y locales \
    && locale-gen en_US.UTF-8  \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get install --no-install-recommends -y \
    gnupg2 \
    build-essential \
    libpq-dev \
    curl \
    gettext \
    libmagic1 \
    bash \
    python3 \
    python3-venv \
    python3-pip \
    python3-dev \
    python3-wheel \
    ansible \
    openssh-client

FROM base-build-stage as run-build-stage

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -
RUN poetry config virtualenvs.in-project true

RUN curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_16.x focal main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y yarn

RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
